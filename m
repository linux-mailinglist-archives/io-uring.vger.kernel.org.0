Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64DE69F95A
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 17:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjBVQyC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 11:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBVQyB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 11:54:01 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F258A2CFC6
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 08:54:00 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id r4so862428ila.2
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 08:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0qvynM9Nxi90Zf3ijS44LI0ZJWfDQBECOfTui8DOr1s=;
        b=qOq/+zo5Xxz8cI2uyt1mgwVciSvbHj8lqyQToCNNWjy+txOmMHTo+tPBt4v7FQ6ydq
         OT0f0NZcc8zIe8H2jeokpTzzrG1uVBMgDJSUZfCIIoLgAFeu0yBQttjvrDZ6HQvxFjFg
         K5hn2qCFUqyJz0OY12pIs/Yx6wRCs8Wn4ShobhZd7HlNgEIhezqDc2x4ZCr7CujcZ/JM
         qQSUG/pdfIzHgXRhShOhILQWld6JppS9UwbB3pUg1aacrgHJ3uTflIuzuQbL1DOIC/3C
         iK3Q9Xhub6T2C6mbm2G0dgCEghWunLA8urYZCbR6SlgwMScOCqh9cJJ4r+kWR8i4J6Qs
         5N+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0qvynM9Nxi90Zf3ijS44LI0ZJWfDQBECOfTui8DOr1s=;
        b=Ck+dwm9YjGFISa5jqDer0GkASqWzN6eVaRUeeQCzSM3tyW9Q/HVhz97CfphT4RU60Z
         8ugWMJWAXglINRbt12VhMez9AcfS92dPCVJ/LtJYFFqJFsph7h2KC33MaC2g337gllp9
         77Om5TL9CeyvdO9dAapSKv6+GR/w1VwzdkO7JgfRMNC/mwytRAqWppNZwgKDj5KXJPxu
         mSmA+UjRcbT9oYgV8ZjIF6/uCm+2mYNJ6AxBNQ5i5IYaxE1Kf8Q9p8gqScQLzLB7uRIX
         c6dbQF8laWPJ6m2RcmWRPDTvwhUEPypkWwILHjO4Wm8c1p0taVBllTrAl1NCC6IVjEWI
         XXMg==
X-Gm-Message-State: AO0yUKXWdxZuyNBXGqJc/pVp5sdtur//znS9J25l6jNi9iUHMPhXdH4f
        rp/DpvR8SR4mvHFvyKoSjqo3KA==
X-Google-Smtp-Source: AK7set95F5KnxN03hgVG9qiVrXp3rRvCM6yIxXPczzGUwGYfn6aCuu+cCGr1d1nNzluZgV8Ep52SLw==
X-Received: by 2002:a05:6e02:1caf:b0:314:1121:dd85 with SMTP id x15-20020a056e021caf00b003141121dd85mr5314715ill.1.1677084840283;
        Wed, 22 Feb 2023 08:54:00 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x17-20020a029711000000b003a7dc5a032csm997371jai.145.2023.02.22.08.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 08:53:59 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5b5f79958456caa6dc532f6205f75f224b232c81.1676902343.git.asml.silence@gmail.com>
References: <5b5f79958456caa6dc532f6205f75f224b232c81.1676902343.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 1/1] io_uring/rsrc: fix a comment in
 io_import_fixed()
Message-Id: <167708483969.23363.8868328168015759553.b4-ty@kernel.dk>
Date:   Wed, 22 Feb 2023 09:53:59 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-ada30
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 20 Feb 2023 14:13:52 +0000, Pavel Begunkov wrote:
> io_import_fixed() supports offsets, but "may not" means the opposite.
> Replace it with "might not" so the comments rather speaks about
> possible cases.
> 
> 

Applied, thanks!

[1/1] io_uring/rsrc: fix a comment in io_import_fixed()
      commit: 81da9e3accfcf978b87300629190d164228c8b8c

Best regards,
-- 
Jens Axboe



