Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E251EB31F
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2020 03:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgFBBtN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Jun 2020 21:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgFBBtM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Jun 2020 21:49:12 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798DFC08C5C0
        for <io-uring@vger.kernel.org>; Mon,  1 Jun 2020 18:49:12 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n2so665614pld.13
        for <io-uring@vger.kernel.org>; Mon, 01 Jun 2020 18:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=oAacEMkc6iH6G+PGZQ4e+RX3FY7H8/j8gGJw9mm+Qng=;
        b=LnZuSMPeDmjd9+wWQU7Mt9Lx8jqnzQyk2rgeMPu/pcRrL5WwtVj3EzItbcWmPSJNpU
         v6M419VD/rnhL03pxXQrCPAwH5EOBoyGoitFDs/JTOu2SCOYsdV18bzHke9S7LGc5u+O
         if7GtH8pU/F9EOBnn6krB3N6AsIouGd4F39YUAPvyPh16iShJczenVFiBN8hrKRaWrxU
         ZkXHTPXnwkev2jHQHkLKrZfF1tMF7Fhm1vTrJHRADQQA5Sf2ilVE98eiAKfKRdtYRCYN
         MWuKkP7/FbZblnL2JF9+ffT9KavU7rZvTYz2ckvkfj0mK84F3eMApSy3DcltldxeVdCO
         OuLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oAacEMkc6iH6G+PGZQ4e+RX3FY7H8/j8gGJw9mm+Qng=;
        b=JDQRr8ObYW1DJpqpEk2XHtXoW5VujmUx8RY6G3mzTiJxT74HEpl2SxhV/GTz2fwv+J
         /tih8nynD1JK9clat//LinLNH5bGbj9fguO3taJqHx9fZ1PNZH1iT1yWTNpdywZ04p8h
         Fy0W76dPVe/2jAKWuZvQiJAvclnl+TKpusosBHhidFwTFDtrZSViHR4B0mZy1trTDm9Z
         9yZ47lc7/h1890+vFy3QreG+WFe0Pn1ndPuWnX9aHOkV4jHvkcVbfvivwl3K+6e6o8Ku
         LnqiDn+vmUcV//mmMl8iDRx4H05OCB5fZl5KcYZTZwj2zJd2X54GYjTnkdCB7eGL7mnJ
         CaXw==
X-Gm-Message-State: AOAM5311WLJpSFAyIii1cgZLwPRYP/z3pAePaFIviZtuszLPmRsTpuun
        zagkg39skZftr6H4kYbchpDQDSyNa6r+cg==
X-Google-Smtp-Source: ABdhPJyJa1A2Mw+LHkr8LMhjsDKMqy1ohA7JgTbFwP9gw4AVkEmDdDJdRVVfwd/nUAEe2STWVfj9Fw==
X-Received: by 2002:a17:90a:8089:: with SMTP id c9mr2698514pjn.126.1591062551455;
        Mon, 01 Jun 2020 18:49:11 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u4sm1408133pjf.3.2020.06.01.18.49.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 18:49:10 -0700 (PDT)
Subject: Re: io_uring: open/close and SQPOLL
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <b5860d6a-8db7-edf2-d58a-2d7d8b35edc1@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <675e74df-e272-2cb5-3681-ce6547c49477@kernel.dk>
Date:   Mon, 1 Jun 2020 19:49:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <b5860d6a-8db7-edf2-d58a-2d7d8b35edc1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/30/20 1:45 PM, Pavel Begunkov wrote:
> Do I miss something, or open/close/etc need an explicit check
> for IORING_SETUP_SQPOLL? E.g., now an open() request somehow
> returns -EFAULT, and that doesn't seem good.

Probably best just to disable them - can you send a real patch?

-- 
Jens Axboe

