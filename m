Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E6A41FA66
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 10:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhJBIOE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Oct 2021 04:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbhJBIOD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Oct 2021 04:14:03 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E060C061775
        for <io-uring@vger.kernel.org>; Sat,  2 Oct 2021 01:12:18 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id v19so8108824pjh.2
        for <io-uring@vger.kernel.org>; Sat, 02 Oct 2021 01:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fTT9hk/adqzzsTlMwr4q/V0eeAOvetJlZUp7aePih2g=;
        b=ZbjKPgSVlv0VNpAeH7c1kuE3RtdFTKVwyuc1aKrKY6vUEjb2owGw8El3GJTC6SP28G
         tzJIL2+fmDmm62FSx06vf9IyI+47nx9BhGsuEqDYzADSyFR9hAwlCJykVBQeS8FsHwwi
         fhA0ftGysQbYjE3e1LwOVdnvCfyzeCQrrwHo6caXa+MMU92a+Buhv5tXvWQ3b4ZQ4vaB
         J0b/0+xhqolHAIeXy/L23DEpt6wGQugtugLHPxpa+RRC5Vi0je5DlTeQun9bAGCn9V7k
         y9JrZMxhbSPJ+cIqFBkW9zoLJGxnfCYq4aBRQme4R6whkabuh2dPku6419y0/V3oLM+c
         kdUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fTT9hk/adqzzsTlMwr4q/V0eeAOvetJlZUp7aePih2g=;
        b=WHNaxLDMXKrRt3880aWE+Uv6Ji79J5TqSAI+XcYiAXIdlM1bGUbT0ZYCpJCFBqizqH
         gtt8BksL+Faj5QEWufDDKY7mNh8ahT5w3+lKyRNdmnlNOS74SQVpizhdVw7RbXY0ysLL
         oTBAHQY32qK9zlkzoqptfjExPSjigMH8gZT7r1D7dH+IVpqmwHGwE4wU0W+Qx6yHuFao
         1EwveOPMV1RvXl8nFmFdaESCAdzvXbee1XEHGsIckxfiYNILWrmbIIxVKS+OiR2Y7ad0
         joy+0pe/9N9pz6QPekM6/SLfQaIZzdiDeK6+A8GHoto25R0J/6iBLVtF/ZH0rqo5+7je
         GwXg==
X-Gm-Message-State: AOAM5315e21ZAK1QnQPFSZq3y5HRLSBMbEACDWJybONvO0zvCx3vzsRy
        UnC1flkcIAjzAtsgCyk1StETWzIGLYTCOQ==
X-Google-Smtp-Source: ABdhPJxJ+zHR/YSPNghDhVZKDeeQOQRx/HlivMVDUbEvUpkIgV03cTkqPncJQ8Jmn2gwafgCtJJUXw==
X-Received: by 2002:a17:902:9887:b0:13b:9892:860b with SMTP id s7-20020a170902988700b0013b9892860bmr13139184plp.65.1633162337693;
        Sat, 02 Oct 2021 01:12:17 -0700 (PDT)
Received: from [192.168.43.248] ([182.2.69.211])
        by smtp.gmail.com with ESMTPSA id w12sm7818957pjf.27.2021.10.02.01.12.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Oct 2021 01:12:17 -0700 (PDT)
Subject: Re: [PATCH v3 RFC liburing 2/4] src/{queue,register,setup}: Don't use
 `__sys_io_uring*`
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Ammar Faizi <ammarfaizi2@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>
References: <20211002014829.109096-1-ammar.faizi@students.amikom.ac.id>
 <20211002014829.109096-3-ammar.faizi@students.amikom.ac.id>
From:   Louvian Lyndal <louvianlyndal@gmail.com>
Message-ID: <d760c684-8175-6647-01c5-f0107b6685c6@gmail.com>
Date:   Sat, 2 Oct 2021 15:12:12 +0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211002014829.109096-3-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/2/21 8:48 AM, Ammar Faizi wrote:
> @@ -158,7 +142,7 @@ int io_uring_register_files_tags(struct io_uring *ring,
>   		break;
>   	} while (1);
>   
> -	return ret < 0 ? -errno : ret;
> +	return (ret < 0) ? ret : 0;
>   }

This is wrong, you changed the logic, should've been "return ret;".
Not all successful call returns 0.

>   
>   int io_uring_register_files(struct io_uring *ring, const int *files,
> @@ -167,12 +151,12 @@ int io_uring_register_files(struct io_uring *ring, const int *files,
>   	int ret, did_increase = 0;
>   
>   	do {
> -		ret = __sys_io_uring_register(ring->ring_fd,
> -					      IORING_REGISTER_FILES, files,
> -					      nr_files);
> +		ret = ____sys_io_uring_register(ring->ring_fd,
> +						IORING_REGISTER_FILES, files,
> +						nr_files);
>   		if (ret >= 0)
>   			break;
> -		if (errno == EMFILE && !did_increase) {
> +		if (ret == -EMFILE && !did_increase) {
>   			did_increase = 1;
>   			increase_rlimit_nofile(nr_files);
>   			continue;
> @@ -180,55 +164,44 @@ int io_uring_register_files(struct io_uring *ring, const int *files,
>   		break;
>   	} while (1);
>   
> -	return ret < 0 ? -errno : ret;
> +	return (ret < 0) ? ret : 0;
>   }

The same thing here!

-- 
Louvian Lyndal
