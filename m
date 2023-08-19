Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4889781A4D
	for <lists+io-uring@lfdr.de>; Sat, 19 Aug 2023 17:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbjHSPG7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Aug 2023 11:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbjHSPG7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Aug 2023 11:06:59 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0CA27D30
        for <io-uring@vger.kernel.org>; Sat, 19 Aug 2023 08:06:57 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-5657ca46a56so287623a12.0
        for <io-uring@vger.kernel.org>; Sat, 19 Aug 2023 08:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692457616; x=1693062416;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y1+u/3U9NY3nXLqHX+dEQ6zy4xPUovp7Y9mOff6zC6M=;
        b=S357DAjBtXPa3YyhS5GMaWU+ZiyDhb1l8xVCOU81oZyM2muAZYT/vp+R/Zgv3lomD4
         HkajeL2hu3R0Ku9V4Pu4i/59hojWrhIl9/Db2Cg+wXhqiIsJsJd85J+akWppgZKd5VzR
         2NTeuAWRy1fcHnNP9WEQ0gwdxlIB+K6cIhdpetZJLx1lY5muo1dSH54PFOMkeByQCe6e
         jrUZog99fke3Fsy7Vs9uVaBbdC3h3PzbBhbRNtTgxDjV6M6jBBL1nZyB4GKKwwSTw/M7
         LogQKSM5kkyvWDRBUeJlZRNwo3lmekThpSSbXzreKWFhXfB49r93s2B9Cj65YGs0R15w
         v06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692457616; x=1693062416;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y1+u/3U9NY3nXLqHX+dEQ6zy4xPUovp7Y9mOff6zC6M=;
        b=IzJyeIO4OoEt+gp9wb3jn2WM+h1XjvSqwhpCf1GKktOo3va7KrZWkhi2lTfMV5lYVd
         AlMgTTScNjXeDs0vkBHvVd6+T+fe7qLOJxJ+YhebTEjNqh2v+Q/9rNxQ1636eVUVjGP5
         pj/5TVX5NvscDzNWvJ2HPDpHEA2Z32Bco2FlBOC6HC5dGqqcPAqrDry9f1mXDX7G5p07
         rr8nWqUrtuoUeMD8WRcJVrNmy0CAFgDCSgzG4/ve+tP5B1j1XBBU/ehEN17MqpBO2aKC
         dj4YxJcEeP9Tf53lA2TfelmZ0kmwKBfcjxqmLzEl72fq8OTMGmM+5nEpDBI6Mqvpheln
         3F0A==
X-Gm-Message-State: AOJu0Yyol+llM2XbQMTnS6CZlig8+wwt4YgkP3/QzsWgyFtLcSaOsz+5
        eQRhkPbprBw+khPoKBwaVBbDng==
X-Google-Smtp-Source: AGHT+IGOzw5pKIfjng3T+XKgTaC9r7Et+HfWJX2rNGGeYgwyzQlZ1+04hoMMuEMdmorIImat3iPXuw==
X-Received: by 2002:a05:6a21:788a:b0:13a:3649:dc1a with SMTP id bf10-20020a056a21788a00b0013a3649dc1amr3635552pzc.0.1692457616489;
        Sat, 19 Aug 2023 08:06:56 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id bm17-20020a056a00321100b00689f423ba7csm2384238pfb.33.2023.08.19.08.06.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Aug 2023 08:06:55 -0700 (PDT)
Message-ID: <4dce8088-305b-4b58-96db-0fba5c8ad21c@kernel.dk>
Date:   Sat, 19 Aug 2023 09:06:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/16] io_uring: add option to remove SQ indirection
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1692119257.git.asml.silence@gmail.com>
 <0672f81d64ffe9f91835e240d8fef7a72bd895ec.1692119257.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0672f81d64ffe9f91835e240d8fef7a72bd895ec.1692119257.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/23 11:31 AM, Pavel Begunkov wrote:
> Not many aware, but io_uring submission queue has two levels. The first
> level usually appears as sq_array and stores indexes into the actual SQ.
> To my knowledge, no one has ever seriously used it, nor liburing exposes
> it to users.

liburing does indeed not expose it, fio does use it as it's using the
raw interface. But yeah, definitely not needed for most cases and I
think this change is fine direction wise.

-- 
Jens Axboe

