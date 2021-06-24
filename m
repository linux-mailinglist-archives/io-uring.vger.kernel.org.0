Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220383B3258
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 17:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhFXPP2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 11:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhFXPP1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 11:15:27 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAADC061756
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 08:13:07 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id x17-20020a05683000d1b029045fb1889a9eso5453402oto.5
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 08:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JQFaIhMPy4Vu968Gptx/lzWxrgza+FbQ5oCqWR+X48s=;
        b=uF7aTKGducB9HXleKy/cyQK0hqoaOi9xVPl4/XlNgKI52xevqbJVDUimRt+cmV21t/
         2p7CvH5PaqqyF8kHqSCNiHnx+cwf0d4pG95k/Jsf9IoP9mA6O3zFHNbLKo2m6s2r81Vf
         KfA0Sk1Tw9FTkDV9nIM+CyKamL0GsgvUVVIFxCOzSyBYntXapK8UVMZ5xotSoXPIwBKD
         Il791iDPhCya/Q10Id52GUE+Yuh9LMHSzntRU8NFwtpd77RhwpzkUomz0vsQtiTwX0cW
         Vql057XB6m3Szi0yCJEfBCMdYkwiEiaENY37g2XNGDLm2ysCHHwZXoMVUWnGVqKk4dSU
         56HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JQFaIhMPy4Vu968Gptx/lzWxrgza+FbQ5oCqWR+X48s=;
        b=CQQugM/YZ5bXciT8cgMq6II6nbmS9xkD6dQkPCaDPCu8gOIDjJK1Fe5vvgChQVENn/
         3no8PDW4zfZ5YwEm2eOIr7DZw3rBxgwBRJ23RC3IIQqWLQ8BIqwDtYmNAvv1QxIzsL9t
         3sT060a1JXDC4y6wx7N7AEB/eT8gZT+Rzi/ifMQhTpAKpMbzCDe7M2XdyoyRk/yQxDBr
         dMQtS/SS9evpcZtwIJlDu7ikYUBWn7iM9HYw1ZAhWfQFgSalJjZ3L6rbS131H8hTsQUn
         CB2qdHU1fe1oxzKx0dM4uWEjQmHGz+Gp8IzDVTu1NR54V285MQ+iUX/jr7tE/dYndSFB
         DPdw==
X-Gm-Message-State: AOAM530OJIDW1bmA1fTrTuBReOkZc9cJaCq4oulUddDznjm3rIC0MQHf
        GJP4yBjG/kZ0Z3UCl45By9/bNRL9QuyIAA==
X-Google-Smtp-Source: ABdhPJy/flzWFBckD1SkRVmcuiqyzqMYQRxQjHS/rYay0fiGShyh/DOAmxM62Ajrz4hp+zEfHQcidg==
X-Received: by 2002:a9d:718d:: with SMTP id o13mr5028048otj.271.1624547586509;
        Thu, 24 Jun 2021 08:13:06 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id k84sm687898oia.8.2021.06.24.08.13.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 08:13:05 -0700 (PDT)
Subject: Re: [PATCH v6 0/9] io_uring: add mkdir and [sym]linkat support
To:     Dmitry Kadashev <dkadashev@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20210624111452.658342-1-dkadashev@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <17ff5921-9b47-94e7-af49-7d626fba9c32@kernel.dk>
Date:   Thu, 24 Jun 2021 09:13:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210624111452.658342-1-dkadashev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/24/21 5:14 AM, Dmitry Kadashev wrote:
> This started out as an attempt to add mkdirat support to io_uring which
> is heavily based on renameat() / unlinkat() support.
> 
> During the review process more operations were added (linkat, symlinkat,
> mknodat) mainly to keep things uniform internally (in namei.c), and
> with things changed in namei.c adding support for these operations to
> io_uring is trivial, so that was done too (except for mknodat). See
> https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
> 
> The first patch is preparation with no functional changes, makes
> do_mkdirat accept struct filename pointer rather than the user string.
> 
> The second one leverages that to implement mkdirat in io_uring.
> 
> 3-6 just convert other similar do_* functions in namei.c to accept
> struct filename, for uniformity with do_mkdirat, do_renameat and
> do_unlinkat. No functional changes there.
> 
> 7 changes do_* helpers in namei.c to return ints rather than some of
> them returning ints and some longs.
> 
> 8-9 add symlinkat and linkat support to io_uring correspondingly.
> 
> Based on for-5.14/io_uring.

Thanks for respinning it! I've applied it, thanks.

-- 
Jens Axboe

