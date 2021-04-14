Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D4E35F914
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 18:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhDNQlf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 12:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbhDNQlf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 12:41:35 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7275C061574
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 09:41:12 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id i22so12962221ila.11
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 09:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=TZPtgtwFaUvPQ4mKrbyoXf0/keAmXalEB85jgQGchbA=;
        b=YVplemGDY5e+CZ8r5BWd4h65twMinoocsjQeVSsTuhgWxAvhgQ3qCFKS/wy4gHLeJX
         fRIoToe2shFMPSwXYL5BPg13UdxSPnlIQMoTSxxoTByqpBJHvrF7q5k7BFyWhmGzFP2L
         CRjS0ZvwNTXC2WUXIPpf0p7bNCiF6+jbc5es1JHEYWXBbeehOyI5tdlqFbbhLV3xLuCs
         1BU1CXEdF20J9VVMJ+ig/FrSFCjoUwBMQH9SvwCluL8mjnfVhWuT9CBKFZqRjMWNo8AN
         F64m3IkO29GmeXtLYnXIeefGF646g0SI7KSd9Lxmf1liVg0ldB4FJaKSDZVAiOk5uQx+
         SJ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TZPtgtwFaUvPQ4mKrbyoXf0/keAmXalEB85jgQGchbA=;
        b=fIbyY7bit2fwmKMkAcfwXLCeoeJ2qqlCFK29LHiTV4zNCcWKZBn5A3zoiWoJGmxqSW
         qpSriblaq6ZtNWXFD/t2k4bCUSR3ybWsD35/GfSPt3kxiE0EOSGbX2R/DnTzQ6mF6rdz
         ga+e6MOA6WS76D0IAPVGaJZQxVHembrBIC8b9MYU2losv5WPpMdx9aCZVr6TfJWFQ5gn
         YRiZkK21HcFsqPL6+EsdI01k2jzNWrC9XAVP+BNAiZKQjt6JaxTUw7VtesuJkv5TqT8d
         yYGA0tUx5gxDx9PdV4UsnZ2lkMtybhgFUpeXfdgURTC0giBKLqrQ+mWk72VMbeYfqIHS
         /JfA==
X-Gm-Message-State: AOAM533CDSBxe01ETsBFgyyrNc2TRI13c62u1WIe/KpWUYrHZTX9TZYK
        cIHiPjlwOtzzRakywf6VYI8WX+PhGoh2kg==
X-Google-Smtp-Source: ABdhPJx45M99n1/F1+vvMX/G/Hx3voCINruM50UkZD1onqZytOoa8NXJFKP9z+vAa7Ka8+ia+ggaFg==
X-Received: by 2002:a92:2a07:: with SMTP id r7mr33539569ile.213.1618418471778;
        Wed, 14 Apr 2021 09:41:11 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y8sm34610ilh.68.2021.04.14.09.41.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 09:41:11 -0700 (PDT)
Subject: Re: [PATCH v2 1/5] io_uring: improve sqpoll event/state handling
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1618403742.git.asml.silence@gmail.com>
 <2c8c6e0710653bf6396ea011be106dcb57e175fc.1618403742.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <159378a6-082c-d11a-ab36-03f851878c76@kernel.dk>
Date:   Wed, 14 Apr 2021 10:41:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2c8c6e0710653bf6396ea011be106dcb57e175fc.1618403742.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/14/21 6:38 AM, Pavel Begunkov wrote:
> As sqd->state changes rarely, don't check every event one by one but
> look them all at once. Add a helper function. Also don't go into event
> waiting sleeping with STOP flag set.

Can we defer this one to post -rc1? It'll cause a conflict with
5.12.

-- 
Jens Axboe

