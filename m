Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FE5637A08
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 14:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiKXNeQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 08:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiKXNeP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 08:34:15 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48D985EE3
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 05:34:13 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 136so1599692pga.1
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 05:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LkHsW53ssyoiPijIOfUjfPXDhEXLzUoOoVAnZpxyriQ=;
        b=eEgGECfQLeWTtYc8llhIsFZ1FCEYe0+Wk9K5kqS1ja8YiJAhF2R611bQnBzHGcqCU3
         qVgDzBOW9H9PeSN6FL0lByUxaQtvf2N1Pb1JS6acFlqXnC1YUu69Zptm4XvxH7/VuNRE
         4Y0TwAWBoAoCdJAWtauaot4XZu5slpAoMarIyerNX47Rw0GSFKT8VG/gJvzXJVUBwDoB
         XHEhGc3vF2nIP+DDZtcMTeTI1w61Sc9xE6AI7z6NL8ZMR5gZHuy57/mqlveqsZ5xc3hz
         VUbdQHaFd8eETKlvTjWLPvKZf+iGInwmj31Lnz0P/sfJYEkoGnzCRuU0RxDyGJWOw3N4
         kTLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LkHsW53ssyoiPijIOfUjfPXDhEXLzUoOoVAnZpxyriQ=;
        b=pdg60OtU4E34+EaeN/xDceQ6dzLTAB9GoAB+WYyfRz+4fYtXuXIAuyzYQ2rbxkrhZk
         Nb/gojWD2U8oOI0ebMxf3t7hlq+vMjwR/zAXEzWLr7RZLALDQQWWFR3X0U2tAFfeOGj+
         qUpOTG21+6vhIReAjAfRkieCdtxFehaUb9foTcdKZ9iijcQJMwV0DjY9jYgeRZLRhQoj
         1WENqgkkLVZ7FItykmNMN6l0lxR8u5V8FX6uh6Ji/1wMq3HEgI6K0yH5g1idlbN8Ck7x
         luzgXQo21qSigk1tu7jzi/nMir/rcoRFRhvTPy0Jlb8a/DuMLOOHJjmCrb0Zc0cM+3cu
         bCOA==
X-Gm-Message-State: ANoB5pmqUKbjbYO1NKK4dRGESftBRtrrjvhtnwgt8u6vpmn+01JLhqV0
        jExm78y7Stz/D4kbNU5O5Yx/J6g8FYC47F8F
X-Google-Smtp-Source: AA0mqf5ut+GoEpa/ICJrQc3kNpRvnd3uATxcbx9d6QpH8zwfkBjPTodMS0w2UrtfiMtrNW1tIQrwzQ==
X-Received: by 2002:a62:ab18:0:b0:56b:9ae8:ca05 with SMTP id p24-20020a62ab18000000b0056b9ae8ca05mr14160440pff.59.1669296853376;
        Thu, 24 Nov 2022 05:34:13 -0800 (PST)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id c80-20020a624e53000000b00561dcfa700asm1207920pfb.107.2022.11.24.05.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 05:34:11 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>, kernel@vnlx.org,
        Gilang Fachrezy <gilang4321@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20221123124922.3612798-1-ammar.faizi@intel.com>
References: <20221123124922.3612798-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing v1 0/5] Remove useless brances in register functions
Message-Id: <166929685122.52524.1408682990080341796.b4-ty@kernel.dk>
Date:   Thu, 24 Nov 2022 06:34:11 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-28747
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 23 Nov 2022 19:53:12 +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Hi Jens,
> 
> This series removes useless branches in register functions:
>   - io_uring_register_eventfd()
>   - io_uring_unregister_eventfd()
>   - io_uring_register_eventfd_async()
>   - io_uring_register_buffers()
>   - io_uring_unregister_buffers()
>   - io_uring_unregister_files()
>   - io_uring_register_probe()
>   - io_uring_register_restrictions()
> 
> [...]

Applied, thanks!

[1/5] register: Remove useless branches in {un,}register eventfd
      commit: ed62cc1a3048e9aed33cf5fb8f47655fc5175bb4
[2/5] register: Remove useless branches in {un,}register buffers
      commit: a4ae8662b61bee4b89d6953348944030461f276d
[3/5] register: Remove useless branch in unregister files
      commit: 2ca898e57658b0b7a3506c9b97dd6d2a2238c2a3
[4/5] register: Remove useless branch in register probe
      commit: 3a418e3e95d0406b2868d79414065d8fa04f2238
[5/5] register: Remove useless branch in register restrictions
      commit: 636b6bdaa8d84f1b5318e27d1e4ffa86361ae66d

Best regards,
-- 
Jens Axboe


