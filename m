Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4958914903A
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 22:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgAXViB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 16:38:01 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:45852 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgAXViB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 16:38:01 -0500
Received: by mail-io1-f67.google.com with SMTP id i11so3428491ioi.12
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2020 13:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+BrHQKB5nfij+vX08vsx6E0QvFRNc+igfWKJlm1mgiA=;
        b=DBv8uLjFSLKMV5O7UgoCxSNN2aS14tNPGkFNBOzdM1UM/0NGOOh4Y7YyUxBD5Wd4lW
         hbi+5gP3PAsEhYk+TiH2ycs5OGUr7mf5WDIk7OeP9tZ4RWNVD4dFGcaEDTR0YsZGK26P
         cakejgZRNkstaoGrfshia+PSWPknhmT4Xg+nVwfl+NX5aqhreji9qfiu0h5FLmqQ2vj5
         K6zOYUppE/7+OinbLU2C2Lpir8offUWBcpbHZIhr3lsElOujx5x6p+FxoWiuNuwvo73u
         O+GD9gPc4w78vfcM1bonh1feBNqadoDY2tv8AeCog/MsemR5go2XqyTBNuipQflrLQ4p
         y4Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+BrHQKB5nfij+vX08vsx6E0QvFRNc+igfWKJlm1mgiA=;
        b=d/bntF0hDf0vdiECg6VNQ2egXP9EvjiTNhn/TPy6JsnjFBvmNAO2c5lpyKyfU6R4ru
         SOSq4H8wS5WY3D+PqzYDL4WUbhgzx4c2+RqKH6icgpmIC8VSedhzGYA3/F2bpm8wWyGr
         22bNYzOEZnn1egJa44presdcsmHy2GfS6SJCulNspfXyOAeXkqelB7prP7jBve31hPlN
         Ayd7I8AGVg3iyNbOs/E+wnOsTpmMYiGWVdNebICqfSTMu9ikMoFk0Srjy3j3QvJPlV++
         zfgpY/DtjDeeSBcfxsNhIMMCiHMLquDF19hYUQz5UbiXvXLolvCcWQiGCv8Ws9N/GFc5
         S5WQ==
X-Gm-Message-State: APjAAAX0DQib4/JOkFbh2IpgNXcuQZMmIcb8DbD1Fxz+1mO1ma2qwQML
        rYs5RtaMqyyxPQA7p3c/2sTekEwCPok=
X-Google-Smtp-Source: APXvYqx531H0bkeg3pNsuZHceZjZej7sSLqhmm52w07XPXkxKIaXHfBVrZDpV6dhgULFkozNyfC+Qw==
X-Received: by 2002:a05:6638:34c:: with SMTP id x12mr3540066jap.144.1579901880674;
        Fri, 24 Jan 2020 13:38:00 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 75sm1985732ila.61.2020.01.24.13.38.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 13:38:00 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
 <0bbc7cb3-6e04-d18c-4646-6886d02e5a87@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <afede29d-b244-afca-2676-4500a7111a54@kernel.dk>
Date:   Fri, 24 Jan 2020 14:38:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <0bbc7cb3-6e04-d18c-4646-6886d02e5a87@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/24/20 1:34 PM, Pavel Begunkov wrote:
> On 24/01/2020 02:16, Jens Axboe wrote:
>> Sometimes an applications wants to use multiple smaller rings, because
>> it's more efficient than sharing a ring. The downside of that is that
>> we'll create the io-wq backend separately for all of them, while they
>> would be perfectly happy just sharing that.
>>
>> This patchset adds support for that. io_uring_params grows an 'id' field,
>> which denotes an identifier for the async backend. If an application
>> wants to utilize sharing, it'll simply grab the id from the first ring
>> created, and pass it in to the next one and set IORING_SETUP_SHARED. This
>> allows efficient sharing of backend resources, while allowing multiple
>> rings in the application or library.
>>
>> Not a huge fan of the IORING_SETUP_SHARED name, we should probably make
>> that better (I'm taking suggestions).
>>
> 
> Took a look at the latest version (b942f31ee0 at io_uring-vfs-shared-wq).
> There is an outdated commit message for the last patch mentioning renamed
> IORING_SETUP_SHARED, but the code looks good to me.
> 
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

Thanks for the review, I'll add your reviewed-by and fix up that commit
message too.

-- 
Jens Axboe

