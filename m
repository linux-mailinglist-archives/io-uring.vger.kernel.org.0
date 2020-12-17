Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350CA2DD491
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 16:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgLQPuF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Dec 2020 10:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgLQPuF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Dec 2020 10:50:05 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFB8C061794
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 07:49:25 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id n4so27961718iow.12
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 07:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MzPJV88kpSUySx/CDbF5BZmR6GyuUW21vK+T3WPoR+4=;
        b=zEyffiL/855Vs4kn1cIopUfKGTxYBypFKJkoyqVsqoXt745MhdGVjA8VHtbP7OxukQ
         2GhIOj9Y877FuozhSevGH1r4kMixt4xm1q7LBdFOyLPotgC0LNoe3oiPh7BXzFq7MQHE
         pgdW5bhhPo//RFyht8u+RkYxqJfvsku8BFbvDjTIEScN8bYH3azGpUtq2ODU/KgAYIP9
         XkzM0VbP6WlG4jrIPxEbLtpBgxp7HnAi7k+1apZb4t7bGOJ+hWp1NJdexMDjNAtKfqTx
         JvXeWkO1e7TxgEAkx84kBymKVGj+qRlUdwNWZJltIJONqzkVG2lxhsQmBv2LdLyyjkKX
         ug/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MzPJV88kpSUySx/CDbF5BZmR6GyuUW21vK+T3WPoR+4=;
        b=iv6JP/B107JrV9fWNl0dnhYUMdvPS/+HCWN0Ax9ogepY5rW9A59Sn/8vNFPB5kymGS
         CYbrofnGjaVJilm9xRZc+3RRV613adb9p3WEwd/ZpoGUXcYdLYc3W34QID3kiruglX/l
         g+96R6bfBN6RtszUZbd5oZI9hY+Q10G9OmqLWKxsTt28ToWxnTBKWdGBCvpwQxTKrNqc
         U/JHiX7zMRnSlWLMdE0QuZOLmg8s5T0ly92IiYj+8PqM9cKl/RzHsSwg2gnwxkh8xPFJ
         no9Wm4GE3Z4jQqRN/HLRkuvqH3ZLPSOhzYoGK40WW1PcmA0poNlsC2MI6xFp6RbqCtbf
         wjFA==
X-Gm-Message-State: AOAM530LQMTt4oA1KIGbOMifaeB9W1TUEJCl1AtrHpQR0MNVQ16b0hN9
        ZJS1n3xbEsR5cvNH6RcpWbl9tg==
X-Google-Smtp-Source: ABdhPJxe0ELaZvo1Sdk8WjF3yWpCgaC3yHsZWb5BNaLUIsWPpohvpdhCg+6ZX1p9wljUXXTFVWh6XQ==
X-Received: by 2002:a05:6638:19c:: with SMTP id a28mr5790234jaq.76.1608220164502;
        Thu, 17 Dec 2020 07:49:24 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r10sm3385454ilo.34.2020.12.17.07.49.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 07:49:23 -0800 (PST)
Subject: Re: [PATCH net-next v5] udp:allow UDP cmsghdrs through io_uring
To:     Victor Stewart <v@nametag.social>, io-uring@vger.kernel.org,
        soheil@google.com, netdev@vger.kernel.org
References: <20201216225648.48037-1-v@nametag.social>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5869aae1-400c-94a4-523e-e015f386f986@kernel.dk>
Date:   Thu, 17 Dec 2020 08:49:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201216225648.48037-1-v@nametag.social>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/16/20 3:56 PM, Victor Stewart wrote:
> This patch adds PROTO_CMSG_DATA_ONLY to inet_dgram_ops and inet6_dgram_ops so that UDP_SEGMENT (GSO) and UDP_GRO can be used through io_uring.
> 
> GSO and GRO are vital to bring QUIC servers on par with TCP throughputs, and together offer a higher
> throughput gain than io_uring alone (rate of data transit
> considering), thus io_uring is presently the lesser performance choice.
> 
> RE http://vger.kernel.org/lpc_net2018_talks/willemdebruijn-lpc2018-udpgso-paper-DRAFT-1.pdf,
> GSO is about +~63% and GRO +~82%.
> 
> this patch closes that loophole.

LGTM

Acked-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

