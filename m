Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 588BE14C3AF
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 00:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgA1Xka (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 18:40:30 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32855 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbgA1Xk3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 18:40:29 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so7863508pgk.0
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2020 15:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IQPQKZlopfmnUXs0YP1XQLi/0wT/OGaGBs6kSncroXQ=;
        b=TJUEPyiw0H5JuNxM5UxuM1E9W4O4tA6pF34Ywq5w/UJ5Jnn26lsk7hmwNEiPkOQHdX
         cBBNGZKa1hZq7Qn79rNmLAI3fg9lxODlRvLmKOAS4lgJgoz6uywA1QwTRiJAj+jIjT3l
         dAp6xDvdkJjhWZwXv5M3TG6qAjroLEKiZ2bAqFDhj9rduNWb+bMGtXfs0B5fIXKqKFFP
         7IdJBIuqwGP76spUV+Ceaf4q3UDK5/gKLzUJ2am4p2nIoFtQU0YABQqN9gR7ACJV/iOu
         BcMbELBySq8UICa305aFGOxc9lYPRR5S8jb/dGAbPVNqDNWqtrw5EUutGtvhRit/NKgt
         xe0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IQPQKZlopfmnUXs0YP1XQLi/0wT/OGaGBs6kSncroXQ=;
        b=gdMviwIisHGcEOMiRlknfj2YEyiPmzH7UP58aam7XvRBWCifOYp3EEvkTIDFYCY43q
         NnAQ0pJqE+Yh8a8s3rvNJXZEkeM8zviwd4/Fsl6lMGQ4V10rlOtV75cuvkOS2HUFfOfQ
         PZU7Swo+QvkGxeyNZAlsHJnTCPavUzF8a5WkRIeCS2DtChLyMZJIx3oJdf//R8ghoorT
         46rzmRtiBt7TYxPCokYYT8Mt2RqjYr+y5hI2bYn839BgsEDLiC9jWjNolmUqJXcZ0as7
         887ieQ56A9UW6p2NxkoWwJtNdrQG31WAg/D32TtkajM+BAS/thLsGFhPDPFXNduzFbG1
         IadA==
X-Gm-Message-State: APjAAAUMHHH47dig34pIAWtx6SGu/+373R6/qJe3XrBROqHP75OuAhIK
        yvVuS/EVAd8PEcmS4krVMXMq5g==
X-Google-Smtp-Source: APXvYqybF/4VvB48u6b6WP7AhKOC1R40epoCYnNitc3PpZ+tMPINNazbX71eE9G7OCsKxOejz4tSMw==
X-Received: by 2002:a63:2b52:: with SMTP id r79mr26965311pgr.230.1580254829069;
        Tue, 28 Jan 2020 15:40:29 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e2sm143862pfh.84.2020.01.28.15.40.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 15:40:28 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
Date:   Tue, 28 Jan 2020 16:40:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/28/20 4:36 PM, Pavel Begunkov wrote:
> On 28/01/2020 22:42, Jens Axboe wrote:
>> I didn't like it becoming a bit too complicated, both in terms of
>> implementation and use. And the fact that we'd have to jump through
>> hoops to make this work for a full chain.
>>
>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
>> This makes it way easier to use. Same branch:
>>
>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
>>
>> I'd feel much better with this variant for 5.6.
>>
> 
> Checked out ("don't use static creds/mm assignments")
> 
> 1. do we miscount cred refs? We grab one in get_current_cred() for each async
> request, but if (worker->creds != work->creds) it will never be put.

Yeah I think you're right, that needs a bit of fixing up.

> 2. shouldn't worker->creds be named {old,saved,etc}_creds? It's set as
> 
>     worker->creds = override_creds(work->creds);
> 
> Where override_creds() returns previous creds. And if so, then the following
> fast check looks strange:
> 
>     worker->creds != work->creds

Don't care too much about the naming, but the logic does appear off.
I'll take a look at both of these tonight, unless you beat me to it.

-- 
Jens Axboe

