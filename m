Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4541698890
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 00:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjBOXEr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 18:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjBOXEq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 18:04:46 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6502109
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 15:04:40 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id d2so108745pjd.5
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 15:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676502280;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=seGBoqONyx8J4QTmHaukgu8E9y5rDa9dSZDJtXrTC8w=;
        b=UuDbRqVr1wwua6UDu3BVUK9GPENy5tL8DqVAkc1ccRZ9VrnJNYecki7cgPJDyLp5/v
         B/47iUzRmlPdDDnYr3EQTZn//Pkk2ccn+ZvUSWkUGxV3jEDA0dZmueksvj80JDB2SPL9
         O38pMMP7wBVnnSMPgZsJTHjFsbhyXYKQd7zvUIduKBPapJVjipn7wdpio+0xPS5QBGpC
         +0z5VwkEA8HodQ4p/wWQ8n1HXJ9SuRlslfKg9QxAql4rJaK8QoCMosxHGUU74K1ao7Ra
         qtCtWOpvay4sxlG0GZXJggDyGZPdxsLRCYZsXSdeBlpi7qDJTuIK86AmBD/yf9YS4yXz
         09EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676502280;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=seGBoqONyx8J4QTmHaukgu8E9y5rDa9dSZDJtXrTC8w=;
        b=ccxzOYKMoMZd6aJVVDmLPLG+Lio5v7lPpo5PiSTvVEAjBQmMzokA+T3JqyGxeEFoEo
         R4J57d0+f/2HeZjBUNi/XkgxsEPhCvIUgXHFhXqvknbx7DMsQHFsc2Er9zhW7Sejtkwb
         /xoEDdiH5V8kWJHDG1CMLv1s+eT19FfLlMZBgtBubOMfNdpzpQaIaCSjhIt1RVU4G8Ec
         /BGDBZYOI5tGkhd6bCq5a3QbxcBKf68smlJWzT64s3Kd0NZtfHDA8GwcHgImWt46SrUF
         T3/5Ykzr8KFUDmMb5lZvZs6hhagGEQ6PqVzshz/DBq77dzhQVwzibxbjLmGxZ9+OMfro
         s1XA==
X-Gm-Message-State: AO0yUKWFiPEijEHigdYaKXq33/EW0floNyWYjPAMvWIR25GmY8JNaibc
        HjgPwKflTyanPm5sWHjHzNE91Q==
X-Google-Smtp-Source: AK7set+aaOXFBCOmk7Kike52cicF9WWZs+v5Gkm/VyeP8AOpJXYMA7tF1s4mdn5PSvDiKUsC5coehQ==
X-Received: by 2002:a17:902:e80b:b0:19a:a2e7:64de with SMTP id u11-20020a170902e80b00b0019aa2e764demr4438699plg.0.1676502279936;
        Wed, 15 Feb 2023 15:04:39 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b4-20020a170902d30400b001994fc55998sm718026plc.217.2023.02.15.15.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 15:04:39 -0800 (PST)
Message-ID: <71047787-1da3-f764-b482-58b33bd108e7@kernel.dk>
Date:   Wed, 15 Feb 2023 16:04:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc with VIPT caches
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>,
        John David Anglin <dave.anglin@bell.net>
Cc:     io-uring@vger.kernel.org
References: <Y+wUwVxeN87gqN6o@p100>
 <006e8db4-336f-6717-ecb0-d01a0e9bc483@kernel.dk>
 <626cee6f-f542-b7eb-16ca-1cf4e3808ca6@bell.net>
 <5f02fa8b-7fd8-d98f-4876-f1a89024b888@kernel.dk>
 <2b89f252-c430-1c44-7b30-02d927d2c7cb@gmx.de>
 <f7c3ef57-f16c-7fe3-30b7-8ca6a9ef00ee@kernel.dk>
 <1e77c848-5f8d-9300-8496-6c13a625a15c@gmx.de>
 <759bc2f7-5f9e-2a62-aa37-361dea902af5@kernel.dk> <Y+1RSYoZqZvqH/cb@p100>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y+1RSYoZqZvqH/cb@p100>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/15/23 2:40 PM, Helge Deller wrote:
> Here is an updated patch which
> - should support other platforms which needs aliasing
> - allows users to pass in an address in mmap(). This is checked
>   and returned -EINVAL if it does not fullfill the aliasing.
>   (this part is untested up to now!)
> 
> 
> Jens, I think you need to add the "_FILE_OFFSET_BITS=64" define
> when compiling your testsuite, e.g. for lfs-openat.t and lfs-openat-write.t

I fixed this earlier, just adding O_LARGEFILE to those two tests.
Did you test before that, or is there still an issue?

-- 
Jens Axboe


