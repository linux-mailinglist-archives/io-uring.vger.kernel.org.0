Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFDA69FA61
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 18:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjBVRsd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 12:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjBVRsc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 12:48:32 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE661E1D7
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 09:48:31 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id 76so3859583iou.9
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 09:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1677088111;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MimG2CC7XI+xnSukS469ABX7/F4IMdTNNw9CfOi9O/Y=;
        b=0tmeqmX8+Wg5duoe+V4dUFkiq3S+jxhY4ftJOaEHzGhztyRfum83E5MwabaFYNraKJ
         TEFdLdtVmtvj1WdJX6+35hJH+hY6js2CMlpNvBnzHhM6lYmCGF97PPl/v0dMk63394oZ
         LTDAHBkmcZj8iNe8HlhfO6sP7ZBUdkXZkc0LjL5D3/ltIqkFsex7mdAW25bNdcJdVpm5
         3DAqYKyEU+ZFBSLHlhGfzf0vv67iY3QPLtvEh/JhQ6IfwZVtEP5BlGJY9Qr6zjj9gV2W
         bBQQ5l14kii+bcGvOVRtN/Pi7sq32RcyWltVffdguxKzk6P7kNl7gRS8jaxHHL/r/rDU
         zJHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677088111;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MimG2CC7XI+xnSukS469ABX7/F4IMdTNNw9CfOi9O/Y=;
        b=EHGoYQjXxLNQkuEP+ggHH+Rntg+cFqRZCQGa7PwjmU57OSvpzJpp9GZhKu4Ze4V0+Z
         I7/VVrJ4kq9VSIddAVsCEc2FR0xMDZM8cdBKOdW7GAMobEwjDSyqePcQza8ML06k4OIH
         +A6l4yPgBFXmHI7sM3eE3xbDkZT0Fc2ktjwqZBlVkPN8hbwU/IROlKBN5Bv51U8vFqMJ
         CbfeaYKc8hSmCZKWIIwsQ2EYmiFpPJm9AjIZX3++DsNJqic9Uc3Qykh05mrBLFTnaE3d
         PEfobTK7idDCWBNulvoag5u4vZC8YXhNQdSyhgBX7ghchjM+wCpEwCtmI3KknFNGgsFa
         AKhQ==
X-Gm-Message-State: AO0yUKXdhm9PSvn5p/2eXSQPqziymJjFV+ytv6ZXPqXrNgIWpoC66Qu2
        WifLLjZzV8Dx4k1uHu2BIEE/IwwSGgYVNnwF
X-Google-Smtp-Source: AK7set/e1YM/12VxyvRllTM9Khpqhg6/GmIeUcMUXgcNxYgKMR5t7TjblPLA8FnTUGI9DwIekhWwvg==
X-Received: by 2002:a6b:8d52:0:b0:72c:f57a:a37b with SMTP id p79-20020a6b8d52000000b0072cf57aa37bmr4419126iod.2.1677088110861;
        Wed, 22 Feb 2023 09:48:30 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x8-20020a02ac88000000b003e44371702fsm508426jan.67.2023.02.22.09.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 09:48:30 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-kernel@vger.kernel.org
In-Reply-To: <cover.1677041932.git.asml.silence@gmail.com>
References: <cover.1677041932.git.asml.silence@gmail.com>
Subject: Re: (subset) [PATCH for-next 0/4] io_uring: registered huge buffer
 optimisations
Message-Id: <167708810999.98463.17204153980405354169.b4-ty@kernel.dk>
Date:   Wed, 22 Feb 2023 10:48:29 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-ada30
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Wed, 22 Feb 2023 14:36:47 +0000, Pavel Begunkov wrote:
> Improve support for registered buffers consisting of huge pages by
> keeping them as a single element bvec instead of chunking them into
> 4K pages. It improves performance quite a bit cutting CPU cycles on
> dma-mapping and promoting a more efficient use of hardware.
> 
> With a custom fio/t/io_uring 64K reads benchmark with multiple Optanes
> I've got 671 -> 736 KIOPS improvement (~10%).
> 
> [...]

Applied, thanks!

[1/4] io_uring/rsrc: disallow multi-source reg buffers
      commit: edd478269640b360c6f301f2baa04abdda563ef3
[3/4] io_uring/rsrc: optimise single entry advance
      commit: b000ae0ec2d709046ac1a3c5722fea417f8a067e
[4/4] io_uring/rsrc: optimise registered huge pages
      commit: 57bebf807e2abcf87d96b9de1266104ee2d8fc2f

Best regards,
-- 
Jens Axboe



