Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0BAA557A31
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 14:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiFWMWe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 08:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiFWMWc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 08:22:32 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B2A220D9
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 05:22:31 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id p3-20020a17090a428300b001ec865eb4a2so2401306pjg.3
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 05:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HRCH0twBoD5za1KdW6qKvy7Mj6OWpjYpvm0HE6kPgAE=;
        b=h/SeNOm6UkC3idMRZXPXeCXjo5wjkDz/gT5SEXKsthgDrPVY6+7W+BdOxWQ8iYfxiu
         jODJrVHKo29YQKoLuXI785HaeYG0B6jzIxgK7u50sTZQzV7AS9Hfs7wmTmYbrs1oX9dt
         j9wzSiK3x1TcJJZG7kIcHhNwj8f6oCk4mdrLBNdiKNDFbHRPmUq2mzNkPl+YekkMorqV
         V23c/cq/KPT+d1d8XMjhNhwE3RcN1XAbGl8uJYb8ezbqaY7hgSNijvySeunBMYoujYrq
         Dm3awCYL6kyeDt9zSLUOEitm1wEFzysoSgKSYV4hQ2foVmi+nvIWGLHf+kGSBBG4Z/OC
         nVNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HRCH0twBoD5za1KdW6qKvy7Mj6OWpjYpvm0HE6kPgAE=;
        b=ZqUGsoYOwFT3jx65Z6lYiIdBaR5MdbjbRJsBvNM9OMeYpO9pqjOLqoipHiKAaP2OKq
         2Nb8QCRlkgtGiJd11Q0dRkScYo4d8059OXOAkECyxvDmO3Cv4vtYSzA3ok3Y60yNWyBd
         jxPpDo5TFSrD0GT/VZxulQ7HrTIF2paD1+2dSUBAfhvEDAqfaT3ougqw7fuf9c8Dkij+
         CM/JVJguB3AOhO/VrejEBGtrO6JYlDdGolJ01Box5TdvXdTvh4YEzfyCIhwDgAqTppk7
         3PuIDfowOLMDvvmODFw9gDY5vMlDowcd2EqxryFsNp9hnJ9aga89pVCm6PCqxJvVAATc
         yHxQ==
X-Gm-Message-State: AJIora+be28yAN0IzZkGUlQP+Q5pwhlHSnOv4jgxdAOI8w7W93qcQVIM
        RhV61mcdhH5fQWyQ6Lsa2L5ZmQ==
X-Google-Smtp-Source: AGRyM1s8khhWzYa58e52kbUP7sQNUGPrIiTEWsR11cl7n6nWJ0cgC8NyiJtRVZs0yZNZ5FBkGR6LVw==
X-Received: by 2002:a17:903:41d2:b0:16a:2cc4:4824 with SMTP id u18-20020a17090341d200b0016a2cc44824mr17612170ple.112.1655986951140;
        Thu, 23 Jun 2022 05:22:31 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z27-20020aa79e5b000000b0052553215444sm1872703pfq.101.2022.06.23.05.22.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 05:22:30 -0700 (PDT)
Message-ID: <3a7f0ba6-d354-bafb-dfc1-b03e7725a0cf@kernel.dk>
Date:   Thu, 23 Jun 2022 06:22:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] io_uring: kbuf: inline io_kbuf_recycle_ring()
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20220623071723.154971-1-hao.xu@linux.dev>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220623071723.154971-1-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/22 1:17 AM, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Make io_kbuf_recycle_ring() inline since it is the fast path of
> provided buffer.

The legacy recycling path doesn't need to get inlined, it's
too fat for that. Let's just move io_kbuf_recycle_ring() and leave 
io_kbuf_recycle_legacy() out-of-line in kbuf.c as a function call.

-- 
Jens Axboe

