Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717554FF4B1
	for <lists+io-uring@lfdr.de>; Wed, 13 Apr 2022 12:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiDMKfb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Apr 2022 06:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbiDMKfa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Apr 2022 06:35:30 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBFE33A14
        for <io-uring@vger.kernel.org>; Wed, 13 Apr 2022 03:33:09 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id s18so3111423ejr.0
        for <io-uring@vger.kernel.org>; Wed, 13 Apr 2022 03:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:organization:content-transfer-encoding;
        bh=FD3EvitDeQpOOlN1vK/20FkCoZM0dxElDZkI93Joh2U=;
        b=GC1/KWjSUA3j+bbLueArTsWoaTVYj3pRBtNuogWvthm5EnOVAcccnR12lTWB5L8Pfc
         MlTeaLlXNeREfp3tzV3QJvgfAm+X92QoIiVOey0uPtgWDB9BD42tlekHEu9QFHxmK6o5
         QpsofyTCGP7ni/tEI9qnB8UvyD+niMuJ+2FoeqbVTnF14adymEGcOoWDnH7l1RxH9S7x
         J8Ay3CZKtUgvg4Ro8r1npZaJb/p8TdUC88Vt6Fk5rJWBWuWOg0vlzi3yGtkkWDdjXGcH
         Q0Np3iivQdQQKMNF2XmCK6anY/SXAifU74lSXxT2MK1izV8941B+9/cwXME45kx7yb6Y
         I+WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:organization
         :content-transfer-encoding;
        bh=FD3EvitDeQpOOlN1vK/20FkCoZM0dxElDZkI93Joh2U=;
        b=0VmPRQraY9E3owTxHAPDKIMYgfgJJKufYw681uTiluJMXkyw6A7MBkc/xY0Ibwg6zZ
         758ZbG2BkQvUZ3KynJ4LNJgLg8r5JVj90ZUhGIWCFs/5TM94NhmHuVw6i9YZ5UsR5i1k
         tuKll6WKcJteqP69fStsB8aNIvErwZeCN0ZAQ6Kvpd24Biid0XpEXaT9OdCxoVei7M4a
         HNohKGIINqVNDrJ7+jrKwky+OG466ZMEh6NNefBopMQTELGN5yfvg3At04CFP2N0Xnvp
         WlbCWSE6nB4Y8+f4tKdDDoUBKU2DwpyBRnWC1QIKufR5HaFgc9FsP6ezV0RGJCaz8lx5
         8uJA==
X-Gm-Message-State: AOAM530f/2yj/RHf1Rs1X/4iTht2UpkQvB9n4FkcbVk8py7beAftHm4W
        BZZ+bT7Go8uSlQrZJtDM2O5RUvqaK9j5zQ==
X-Google-Smtp-Source: ABdhPJzdWG3pRlINpq+SRXikAinvYT20+XTNB1zSuwUgBYGCSMThQ8+tAOlR3c0FrB+5GxAc1qoZnA==
X-Received: by 2002:a17:906:4783:b0:6d0:9b6e:b5a5 with SMTP id cw3-20020a170906478300b006d09b6eb5a5mr39537486ejc.526.1649845987954;
        Wed, 13 Apr 2022 03:33:07 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id f7-20020a0564021e8700b0041d03a94f27sm1014130edf.66.2022.04.13.03.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 03:33:06 -0700 (PDT)
Message-ID: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
Date:   Wed, 13 Apr 2022 13:33:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     io-uring@vger.kernel.org
From:   Avi Kivity <avi@scylladb.com>
Subject: memory access op ideas
Organization: ScyllaDB
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Unfortunately, only ideas, no patches. But at least the first seems very 
easy.


- IORING_OP_MEMCPY_IMMEDIATE - copy some payload included in the op 
itself (1-8 bytes) to a user memory location specified by the op.


Linked to another op, this can generate an in-memory notification useful 
for busy-waiters or the UMWAIT instruction


This would be useful for Seastar, which looks at a timer-managed memory 
location to check when to break computation loops.


- IORING_OP_MEMCPY - asynchronously copy memory


Some CPUs include a DMA engine, and io_uring is a perfect interface to 
exercise it. It may be difficult to find space for two iovecs though.



