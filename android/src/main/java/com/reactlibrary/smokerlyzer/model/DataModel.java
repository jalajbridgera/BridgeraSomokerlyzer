package com.reactlibrary.smokerlyzer.model;

public class DataModel {


    /**
     * key : viewUpdate
     * data : {"message":"change viewtype","viewType":1,"time":12,"isButtonClickable":true,"buttonName":"begintest","ppmValue":4,"isDeviceMode":true}
     */

    private String key;
    private DataBean data;

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public DataBean getData() {
        return data;
    }

    public void setData(DataBean data) {
        this.data = data;
    }

    public static class DataBean {
        /**
         * message : change viewtype
         * viewType : 1
         * time : 12
         * isButtonClickable : true
         * buttonName : begintest
         * ppmValue : 4
         * isDeviceMode : true
         */

        private String message;
        private int viewType;
        private int time;
        private boolean isButtonClickable;
        private String buttonName;
        private int ppmValue;
        private boolean isDeviceMode;
        private boolean isButtonInvisible;

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public int getViewType() {
            return viewType;
        }

        public void setViewType(int viewType) {
            this.viewType = viewType;
        }

        public int getTime() {
            return time;
        }

        public void setTime(int time) {
            this.time = time;
        }

        public boolean isIsButtonClickable() {
            return isButtonClickable;
        }

        public void setIsButtonClickable(boolean isButtonClickable) {
            this.isButtonClickable = isButtonClickable;
        }

        public String getButtonName() {
            return buttonName;
        }

        public void setButtonName(String buttonName) {
            this.buttonName = buttonName;
        }

        public int getPpmValue() {
            return ppmValue;
        }

        public void setPpmValue(int ppmValue) {
            this.ppmValue = ppmValue;
        }

        public boolean isIsDeviceMode() {
            return isDeviceMode;
        }

        public void setIsDeviceMode(boolean isDeviceMode) {
            this.isDeviceMode = isDeviceMode;
        }

        public boolean isButtonInvisible() {
            return isButtonInvisible;
        }

        public void setButtonInvisible(boolean buttonInvisible) {
            isButtonInvisible = buttonInvisible;
        }
    }
}
