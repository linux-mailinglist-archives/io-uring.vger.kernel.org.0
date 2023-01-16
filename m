Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0991366B690
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 05:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbjAPESx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Jan 2023 23:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbjAPESj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Jan 2023 23:18:39 -0500
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31E79006
        for <io-uring@vger.kernel.org>; Sun, 15 Jan 2023 20:18:26 -0800 (PST)
Received: by mail-vk1-xa2b.google.com with SMTP id l185so9617221vke.2
        for <io-uring@vger.kernel.org>; Sun, 15 Jan 2023 20:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QLo9yAHsHm94mDVBHYQdPCAGmoHnGdGAbajlskQEFlU=;
        b=PebSSrjq4KC1GIm7zyXdpU3BlpeF9Ezg2A2wGYiV3WBIA8VYOfBfH5+YOwxuW3q4Lg
         6Lkwfyds4pZjHFDeWAvQbXMASWTkY8bWHbgzyx6reMTn6BieXHFB+cPkPrdpR21WvfXg
         ivsBtzqdxYy7NqxXjdA9MdjfCpbG0//g+r5R1vZYT868UsgfRAoAydU3wzLlGL1x2X2B
         p6Tny1EbMeWiUEoSHnka0VlLxp6LEanSsFOaw8SV8umC8gWpseiUX5KF4vUcD61S+8HB
         QPnbGNj28m7ic1yk4WI4hodYKCtSOXegWShm8QbNpEZkWWF9BNW4Hg6Gj0WuuV9B3mtB
         PNvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QLo9yAHsHm94mDVBHYQdPCAGmoHnGdGAbajlskQEFlU=;
        b=qvHvZcgNJo1THqVhJsqHWCw0wPseRybYY8ujGOy+BAKZCfVkiCaisT3djwQqGwdTBk
         32Uz96kFxDD2pSOuTvtcAK1sNeq4Xiewqxtu5MWkRpBMHOpdaVocoI0NlQIzZB57SAuT
         vEqfWapw6CCxhL/TRcCmXRsHbBXLooCQGhJNIMDD11NX7xEVKB39xZ0DA4ifUjgoHlFi
         pQ5Xm1ndTVmRJdinZcgKfSmzSX8gB2zTAwLzxEa8DSxkC+C9PfYPtMPpPtfmJOpP/mba
         sod0VT11Z4ffOM1S/acC/9TJITAe+nS6CsWnn5Ik+Gw3GN/g4pIwTGV/zOPiHb794D1r
         KmnA==
X-Gm-Message-State: AFqh2kragXgybvvJ3Sy21Bs4hc5yileNXlj6wsURycj0taXhVgC1SfAz
        bg+fumDaM6oL31uymGeaL003ib6n6D6GFO/qWvQ=
X-Google-Smtp-Source: AMrXdXtkm3CGx8KlHvZlG6aAh8AauqHXO6gljquIbdBVSJxE2iu4ppyCWaErOJKfoGBX8/C0thM5VMZhcJtuT9YJqK4=
X-Received: by 2002:a1f:17d0:0:b0:3dd:fa8a:7a36 with SMTP id
 199-20020a1f17d0000000b003ddfa8a7a36mr768436vkx.33.1673842705234; Sun, 15 Jan
 2023 20:18:25 -0800 (PST)
MIME-Version: 1.0
References: <20230114095523.460879-1-ammar.faizi@intel.com>
 <20230114095523.460879-3-ammar.faizi@intel.com> <3d217e11-2732-2b85-39c5-1a3e2e3bb50b@kernel.dk>
 <CAHf7xWs1hWvqb61tpBq63CLFvSk=kfAn_nq_2t2gf7O8V9qZ6A@mail.gmail.com> <34a2449a-8500-4081-dc60-e6e45ecb1680@kernel.dk>
In-Reply-To: <34a2449a-8500-4081-dc60-e6e45ecb1680@kernel.dk>
From:   Christian Mazakas <christian.mazakas@gmail.com>
Date:   Sun, 15 Jan 2023 20:18:14 -0800
Message-ID: <CAHf7xWuX+c1uhPEsq47u9CyqztoGqG4BLwXSen-i15zM1ZFasQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 liburing 2/2] README: Explain about FFI support
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hmm, how about something more like this:

+Because liburing's main public interface lives entirely in liburing.h
as `static inline`
+functions, users wishing to consume liburing purely as a binary
dependency should
+link against liburing-ffi. liburing-ffi contains definitions for
every `static inline` function
+in liburing.h.

- Christian
