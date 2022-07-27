Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0316F5824B5
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 12:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbiG0Kpy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 06:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiG0Kpx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 06:45:53 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D07AC03
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 03:45:52 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id l22so2051879wrz.7
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 03:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=PXhZ09tv+/Jn7SlLU0/N2TIZmBhmcnwXEDKQFUnk3rM=;
        b=jffvKinu/SwrDIvmP3QvXM/ACOgy3+ke64yIUjCZAcYpT9s3lWmvTnbTSxT3leQ6E+
         tIEBIrMvJwz5qsbWQeD5ZU8oznxzcSqV7APvtjahcs37FLlnOOIkihMOU1lF5q8sGCsM
         rShv1g4G695TDzCAVJ7scpzTIUX3RjRbWSwzFsK/hfk3yvYIhnmBWw0ww8H1sVA5AsmX
         tVBURgwz9PxPisxLJnKbctBrpyMkAIajE2lVJDWU/vI0+KWoevHcNnBxS0cObfPs75CF
         9hoLCP28DV9XM4KPm/c5FTpyHSLLg9cSZD0kF/MOwYNRsL/bNvS/luuEaIEBsJgC2zR+
         qQIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PXhZ09tv+/Jn7SlLU0/N2TIZmBhmcnwXEDKQFUnk3rM=;
        b=Q3GmOpZDy/KQebFQI2tXX6kR5CYzBOWts89EL1V2f+qepmSXZCInV6jqt8LIqc2ovS
         uMqKlM6MJr/yr12ZfilwwomgmJ+utmW0pAEKuS9q1WAvcoOMF162DdeofI1LaVJkIRLs
         9iQvLNfNcNLL3KOey1Z7lu2iBTGj5VXWwwRy4knWGvVirv7g+QMtwctLCYY9KWNzN6Kx
         wzzRE1A+cq2jzrWeboppeEUVqVWcU2iWH+GwzpEI4YhqvjIjOgTwuaEtnrMi5rxgTE5A
         0gT6EkaMi0VYWUFQzz7Qj0QejHjx1V+mgLEaUt4JvDTRG/PUb9j4rQcXY9l7DyOLQrY8
         tg/Q==
X-Gm-Message-State: AJIora8fQxNlCgfihFmlnTib972+zHLKfGKJXJ0r/KXIqHk8jcHHMqsu
        NzhqO7PakpEL3CE/b3BeyTC8GkQqLAeWGA==
X-Google-Smtp-Source: AGRyM1vL/HARrGuMdhU9rYADuy1g1lNAOpntSemqetJB9yKJUHg8dTKHl2y1JNfFevexmCplzXaItQ==
X-Received: by 2002:adf:e54a:0:b0:21e:61f3:de49 with SMTP id z10-20020adfe54a000000b0021e61f3de49mr13905756wrm.25.1658918750773;
        Wed, 27 Jul 2022 03:45:50 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:b252])
        by smtp.gmail.com with ESMTPSA id k10-20020a5d428a000000b0021eaf4138aesm4107069wrq.108.2022.07.27.03.45.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 03:45:50 -0700 (PDT)
Message-ID: <29f69069-3f97-29fd-e997-7b318c6d15da@gmail.com>
Date:   Wed, 27 Jul 2022 11:44:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Confused about count argument in io_uring_prep_timeout
Content-Language: en-US
To:     Bikal Gurung <gbikal@gmail.com>, io-uring@vger.kernel.org
References: <CA+v7nzg1O_nw6yicX9uVs7BpaovH7Z0hNgqzKrRLP-_m3XA-_g@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CA+v7nzg1O_nw6yicX9uVs7BpaovH7Z0hNgqzKrRLP-_m3XA-_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/27/22 11:20, Bikal Gurung wrote:
> Hi all,
> 
> I am trying to understand the 'count' argument in liburing
> io_uring_prep_timeout call. Does this argument signify the number of
> cqes after which the timeout value 'ts' becomes armed?

Short answer, if you want just a timeout, i.e. will be triggered
according to the specified timespec if not cancelled, just set it
to 0.

TL;DR;
It's apparently a niche feature I'm not aware anyone is using, it
make the timeout request to complete when there has been added
@count or more CQEs since the timeout was queued. I'd love
to deprecate it tbh.

-- 
Pavel Begunkov
