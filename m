Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53BB4833D7
	for <lists+io-uring@lfdr.de>; Mon,  3 Jan 2022 16:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbiACPAk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Jan 2022 10:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiACPAk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Jan 2022 10:00:40 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF29C061761
        for <io-uring@vger.kernel.org>; Mon,  3 Jan 2022 07:00:40 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id 19so40074772ioz.4
        for <io-uring@vger.kernel.org>; Mon, 03 Jan 2022 07:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iX+J3aUp4/IGEYlAX+jrwzk7n9Ng8QNRRPfY0+N+Kk0=;
        b=HO7yn1sHsLHQ8xV6Fb5gP9LX9CRdwL8v10dc8u0Qz9x1J7mhvwM/WuLdgcLLj+ocHF
         tKYU+TzUGmAhpJj8Rj0+X/XJaOC0/u+OBLLfMLVZF5n95is3OMam9ROEaJUtWEMyURge
         nf3JVFnvfvSdt0QPx41emgEZ0y2MW1ouDMFOH0gW7TP6PJ/B500/5yyto3V4k+KFFR79
         kvVYxR/l182j+Onmfda+fHwr9lwQIkWsOG3cWajZPizzt2u5b6u0cCevtAvskcUATmS9
         tPrZ5olhHdTZZAzlxtYSCS2eH2kpIRLBXaHqJPZQrVNno91OHRl8yktJesxZphVqHSte
         n0Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iX+J3aUp4/IGEYlAX+jrwzk7n9Ng8QNRRPfY0+N+Kk0=;
        b=XVN2ii2xD03O7Llw0kMsVus/ZYjQtinX021inoVjAnWLAss7TJ1mUBELWuSVLbaTdo
         VAFzsx8mOVZCmG5RiCeGbyhOpopXtL8drCEWUq/+CbEYg6mdNIYwu6JiR2wvvRcK52Yw
         RV1GfT3VXW3mMdE/WHqgMibCJZUPbBYGBAeD+8asRUnEQkVBDk5pnBetWykAruoHRgb1
         PSCtBvLLqxzO/L1Ao4LvU/gBGQt0TuPDxLj2RWl+J/TwjijRR8a+BPZkhsjUpqPN0//A
         ItIkW0azYCqjtBB9pYRVCHj58XUaKgzFMSu90qPe2HwRzetjaHDzVJeI5p1ZepVAM1K7
         1bMw==
X-Gm-Message-State: AOAM532P3TRmJobvDyPHH7P76wsBRPvOl4u8iJpTZBTjKrtSnlVUT8E4
        Hf8svH7DYW/uf/znL45tBhwdhw==
X-Google-Smtp-Source: ABdhPJxpUJWBb8t7exxUVuaHvXrw5nM1iSJzHo9x/1RIfXrTiIGXiV1X9VTNjSB411TykyOMMeTNbA==
X-Received: by 2002:a02:734b:: with SMTP id a11mr12608906jae.168.1641222038571;
        Mon, 03 Jan 2022 07:00:38 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z13sm2228796iln.43.2022.01.03.07.00.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 07:00:38 -0800 (PST)
Subject: Re: [PATCH v7 0/3] io_uring: add getdents64 support
To:     Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20211221164004.119663-1-shr@fb.com>
 <CAHk-=wgHC_niLQqhmJRPTDULF7K9n8XRDfHV=SCOWvCPugUv5Q@mail.gmail.com>
 <Yc+PK4kRo5ViXu0O@zeniv-ca.linux.org.uk>
 <YdCyoQNPNcaM9rqD@zeniv-ca.linux.org.uk>
 <CAG48ez1O9VxSuWuLXBjke23YxUA8EhMP+6RCHo5PNQBf3B0pDQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <308dafb1-9ed8-c626-2cf5-34ecf914db4f@kernel.dk>
Date:   Mon, 3 Jan 2022 08:00:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez1O9VxSuWuLXBjke23YxUA8EhMP+6RCHo5PNQBf3B0pDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/2/22 11:03 PM, Jann Horn wrote:
> io_uring has some dodgy code that seems to be reading and writing
> file->f_pos without holding the file->f_pos_lock. And even if the file
> doesn't have an f_op->read or f_op->read_iter handler, I think you
> might be able to read ->f_pos of an ext4 directory and write the value
> back later, unless I'm missing a check somewhere?

I posted an RFC to hold f_pos_lock across those operations before the
break:

https://lore.kernel.org/io-uring/8a9e55bf-3195-5282-2907-41b2f2b23cc8@kernel.dk/

picking it up this week and flushing it out, hopefully.

-- 
Jens Axboe

