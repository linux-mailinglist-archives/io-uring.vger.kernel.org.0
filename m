Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19EF20BD9F
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 03:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgF0Bql (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 21:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgF0Bql (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 21:46:41 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF58C03E979
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 18:46:41 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a127so5393945pfa.12
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 18:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+Fl9/p1pW4eUsRcsYTl5NIgKHt8gl0+TvFzz5VvaK48=;
        b=02bU+Pn/U9ExWgoSYMuYzng1rROORWUAolR7MWBBnPzMdp5OGdRuG5DfpyJATB2ECo
         vFEY0zZK2CX6xhnPWh/iES6RV7WanH4Uvs8bu1NfeHManbNCbzKn1as2nrMhqX0neuzX
         VJDaX9xDPop7GRsA1Z60E9xOekxfiC1UOvSEpJH7OUBUNMpjFggXd3XEQb3YstM4qa1V
         QNzo+wRxiDMVyjE+On/9To5hTVwsf1GVSysy3V2JukU2d8BH+1++OW533NAiMzy8lX3f
         Iwroe38ZLsyuvAp2EbSMF+K5oeYQwvo9sJ5B07VnQLLmwLk1RnIZ7V9pOXDd1v/gmUfJ
         bgQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+Fl9/p1pW4eUsRcsYTl5NIgKHt8gl0+TvFzz5VvaK48=;
        b=QNTLjNiUsymvH9mOQcSAiRDsm829qQRQW0hU7UBpYEbv7ToP0eWN3qqQpixqwMAdVP
         6W2AK85xl/Hg6Xbu1Zv84S92tbcgcPZSSlWa2e2MzU6Rc5duTeh1rPPLLORQez54fUYr
         gEhU+gBCDFf6vDHGQRKs0BDks95Bb0TFfvwe4leXF/ljpBu5G2Cyr4EkfeWhFXK31Lzw
         ABpaesBUVj+wKkvuHBliwlV2a5qdhBEMCgoC55Htt2hgyII5waXVIVz2OKr7o1aswW5H
         pGFL2Kb7i+Mj+vGGFs+iPWQ5KCyShBR/nt7XKlvLAomvIgjJ0TdvBabEUU1O6UXx8but
         Wlxw==
X-Gm-Message-State: AOAM532jhac60I5rd1RR9yRdbssQ74Je88nrwP3jaCLsl29PtfvxHQV4
        9NRgA7C1yMro2SUeuYF7XcaGCxRyA2EW/A==
X-Google-Smtp-Source: ABdhPJwWUwo1S3UflBqAZv2/EMg+9BAisj8FqREik2ihn9oKFVy2QdvHCEl53TXgSjSli1j/tVIywA==
X-Received: by 2002:a63:3c41:: with SMTP id i1mr1400088pgn.349.1593222400583;
        Fri, 26 Jun 2020 18:46:40 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y136sm27334607pfg.55.2020.06.26.18.46.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 18:46:40 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix function args for !CONFIG_NET
To:     Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org
References: <c3db950b-9062-11bd-97e4-afe7c9bf2f27@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bd3919c3-388c-7fd6-e03d-9c1991b089b7@kernel.dk>
Date:   Fri, 26 Jun 2020 19:46:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <c3db950b-9062-11bd-97e4-afe7c9bf2f27@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/26/20 5:32 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build errors when CONFIG_NET is not set/enabled:
> 
> ../fs/io_uring.c:5472:10: error: too many arguments to function ‘io_sendmsg’
> ../fs/io_uring.c:5474:10: error: too many arguments to function ‘io_send’
> ../fs/io_uring.c:5484:10: error: too many arguments to function ‘io_recvmsg’
> ../fs/io_uring.c:5486:10: error: too many arguments to function ‘io_recv’
> ../fs/io_uring.c:5510:9: error: too many arguments to function ‘io_accept’
> ../fs/io_uring.c:5518:9: error: too many arguments to function ‘io_connect’

Thanks Randy, applied.

-- 
Jens Axboe

