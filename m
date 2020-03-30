Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 434D8198188
	for <lists+io-uring@lfdr.de>; Mon, 30 Mar 2020 18:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgC3QoL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Mar 2020 12:44:11 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38521 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbgC3QoL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Mar 2020 12:44:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id x7so8919861pgh.5
        for <io-uring@vger.kernel.org>; Mon, 30 Mar 2020 09:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SBApvJgjclIRIf9AI2rCNRS9oldIy9um65KfCs+4Kms=;
        b=v6Zm6i0J2NIcbRxzeor1TqcndMCPMhD7j/jgOwe+a1bMIs7F4LMH2DHkNKlcIy36Ox
         ZyHwlKU/Tz/IxzCpeeYZKdcds6DLS12gF1y7K2C1mf/alOjQjy8dbf8pqh+9WZsHEWHS
         ScFrK3+cMNSoiBAytnN20vNxQ8WeGkqHVc/4/iX3A/VGn2ORsE4qnX7QN4ApcCsiph/m
         30E5PwL9oHV+zBXvrsI5yKJCQG2s3OXSCIw8v0w6/6ZPaJrVDX9a4p41uVjqmWPlbVlW
         0dOa7ZYelkXTrgWnUbrVn2IIxFrRax43SgMFmFAT2KuHr1Tx+mwwjgJ5wLRJGrNGfld0
         47fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SBApvJgjclIRIf9AI2rCNRS9oldIy9um65KfCs+4Kms=;
        b=FI2QAqRUmOmFDPTQwzo7ExLD9foXurH7KfjQiyMyuYmcMqStvO1zohA/ZgsHFQkTuE
         +1klUGRBVOkNwOmg1ePfBUNE3ZuMmEyRt8qvCbzgSx1tAsVVmWwAOfoMuWeD6bABEAxd
         pNa2pcqqVXgxaHJZEV52XyPOpJxQvvr+aNfBjPZYP2AN6KytOuiQAImay0nJk9rTbeZP
         jK6i9bKtj4D+oH+NlwJuqCBG2XDCFwUkmVmYJYVC8afAdZzjSwSjre94KwNq0wTbETSG
         UMLB8x9KCfuz0tiD2I2dhXyePmCDLsTFNuR9uuwmPcPY9dekL7+/Y/kIeDnnDa/z749R
         HfUw==
X-Gm-Message-State: ANhLgQ3OORH8mDReQ109XFjgSRtRxUAirDe8Hx3aCeXHBydysPLS2k/c
        OmtX2KBX9ABKX8buhPPaPmEveruo2+7pXA==
X-Google-Smtp-Source: ADFU+vu7C8+OULrlEPjSnKC/YYmRtCCUIpmhZzRXc5H86LKrSKQd+5cvsnLMFnVaZo4g016vlM8rHg==
X-Received: by 2002:a62:8247:: with SMTP id w68mr14172228pfd.146.1585586650117;
        Mon, 30 Mar 2020 09:44:10 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id q80sm7945786pfc.17.2020.03.30.09.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 09:44:09 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: refactor file register/unregister/update
 codes
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200324093648.2264-1-xiaoguang.wang@linux.alibaba.com>
 <255357fa-9a3c-5cc8-b15c-927d435bd69d@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <53841bc3-f7b4-c59e-0626-3967732208ab@kernel.dk>
Date:   Mon, 30 Mar 2020 10:44:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <255357fa-9a3c-5cc8-b15c-927d435bd69d@linux.alibaba.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/30/20 12:49 AM, Xiaoguang Wang wrote:
> hi,
> 
> Ping this patch, and should I rebase thit patch against newest upstream codes firstly?

I like this approach, just didn't have time to review/integrate/test with the
merge window coming up.

Once the io_uring pull request has been merged for this merge window, then
please rebase and send a v3. Thanks!

-- 
Jens Axboe

