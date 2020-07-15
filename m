Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DD32216A3
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 22:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGOUyl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 16:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGOUyk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 16:54:40 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE17C061755
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 13:54:40 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id x9so3237431ila.3
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 13:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BSz/uVziT/Az3thaj4shZ6a4cRF0mEYmW9Nk2I0gWZ0=;
        b=Qg78CvpPZ5hBWbWQpcxRyorZ7G24HKMQeBLtZgyVB5TMR0d+LZCOXRydDaZHTOPxbj
         NSyZXcMETI8tzLWdeSYmfecjfaERySRhI1wjgNxY/8wzOpuUFlinR2T7pIaB0C19SgHD
         8CxVqgs7kTpXAiRur/K4hcRUrUVPGJEsIuZ2K9pXme3L5LWNYmZBeYguqtSwjl76avz5
         dd+b+42lM4+k9QkbdDDdb0H/zKvjPpqAsOk1jeNiqCMLFrd64+dIYxzX7VWPtzgn9KBN
         0AxcJrkbSnde8+ytl0SXhjuk7qNv4oRdZaaVOt2Awm5bbpeNfQ6xbi7GbHVVsU7ysmSL
         LPkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BSz/uVziT/Az3thaj4shZ6a4cRF0mEYmW9Nk2I0gWZ0=;
        b=C7xXMrGtlIpnGizur3w0vqa8RXQk02AfG4zIVtHtgOD6Oq2ZyOp/BK/N9QaE3bHjez
         tz82P2AdgpPJgwgJoti5CIS+wwK+pEqXvE3uSbPO3vD3LZ2IM5Mb1hdpi1Wv1irwjtNX
         ms4QbXwPxpXAq9QAagDhLQGSlCQg+sBs1Dsk/1dKg7mhn2CVQgkJsnutBKtGa7n8CvW2
         6C979FigZ47XLwMgae/HAjnXhKilf1LGWHfbv5YXoJar4Oe7STHxeeD6pxfj0GRF5DcI
         b+axbn2DAJREv5j6jwiOqekTOnPWy0IP7ZMbWfuUuzLmWL5Gh6F8nMP9xvSMpmjTFboV
         2Wsg==
X-Gm-Message-State: AOAM531SCx79k3ph47JtpJMllKr0AR/ZjzZyYddI08DSsJ53u6EMF+4X
        6+epa3z8Y0LHb2bqBB4dorVfj5Mz8L1p8g==
X-Google-Smtp-Source: ABdhPJwa+v+fP7HqN7xZPp5Fu03hInCyZBNzx6LA9AbvHmWbmqBfSUMd/f7B3momZF6iAQDE0YVqaw==
X-Received: by 2002:a92:5ecf:: with SMTP id f76mr1247999ilg.281.1594846479758;
        Wed, 15 Jul 2020 13:54:39 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x1sm1598073ilh.29.2020.07.15.13.54.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 13:54:39 -0700 (PDT)
Subject: Re: [WIP PATCH] io_uring: Support opening a file into the fixed-file
 table
To:     Josh Triplett <josh@joshtriplett.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <5e04f8fc6b0a2e218ace517bc9acf0d44530c430.1594759879.git.josh@joshtriplett.org>
 <3fa35c6e-58df-09c5-3b7b-ded4f57356e8@gmail.com>
 <20200715204614.GB350138@localhost>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ee9a8616-0fd5-af8f-fb75-882b23714e02@kernel.dk>
Date:   Wed, 15 Jul 2020 14:54:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200715204614.GB350138@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/15/20 2:46 PM, Josh Triplett wrote:
>>> +	file = do_filp_open(open->dfd, open->filename, &op);
>>> +	if (IS_ERR(file)) {
>>> +		ret = PTR_ERR(file);
>>> +	} else {
>>> +		fsnotify_open(file);
>>> +		ret = io_sqe_files_add_new(req->ctx, open->open_fixed_idx, file);
>>> +		if (ret)
>>> +			fput(file);
>>> +	}
>>> +err:
>>> +	putname(open->filename);
>>> +	req->flags &= ~REQ_F_NEED_CLEANUP;
>>> +	if (ret < 0)
>>> +		req_set_fail_links(req);
>>> +	io_cqring_add_event(req, ret);
>>> +	io_put_req(req);
>>
>> These 2 lines are better to be replace with (since 5.9):
>>
>> io_req_complete(req, ret);
> 
> This was directly copied from the same code in io_openat2.

You're probably using current -git or something like that, the patch
would be best against for-5.9/io_uring - that's what's queued up for
5.9, and it does use io_req_complete() consistently throughout.

-- 
Jens Axboe

