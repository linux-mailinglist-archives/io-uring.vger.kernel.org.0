Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B450638AF5
	for <lists+io-uring@lfdr.de>; Fri, 25 Nov 2022 14:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiKYNNl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Nov 2022 08:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiKYNNk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Nov 2022 08:13:40 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237E52CCA1
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 05:13:39 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d6so3964654pll.7
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 05:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h0HUe6tWhaDxDnvrAogxxmavqFnQikdeTTz24GcpsuY=;
        b=iLckk79MFXzkzymKDchDC2K6ulZ2RmiTairxvp8Lk3/kEW+psISULZpqVvmc/EcN/w
         c6iUm0odqifVkJpO6U53SvN02/TE3JUyIaGUq/zt/rFqWlpiMDeJWXA/NPlVdUKCov/J
         gSV2ubSgNCnvRQXL6DkXIfAMTReNdyW8WMxP7f3VhiVcC/zsR/5f72cBSWygQkGA72qA
         5CNnebDv4gBy5UC7A21A3qmrWQiYDw7KsOElsMO9KXhI9deikcnNO6+tGMzjgyaZdJlG
         /ij2ITnRYR/PMZnrs+xZlux/PVrGkUe9pzr2GvL6wcEVGqCRByy1pWXnqZs68siJUJeq
         /Xfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h0HUe6tWhaDxDnvrAogxxmavqFnQikdeTTz24GcpsuY=;
        b=ymxP/1DYfdKkLflrjFxIQJrfyohvgQKD0/nrQMslSP1OPM8XvFyvd0KhT0Uu/m1s4Z
         w8CjQHPErQDR21yAqkHNWmy3vodUxlkw/ZiRJ1S+TZSM1Q4A7WABLyZsgQo+j0rFl/Vy
         vQZoCroil7HiLiyfAmJk7duELqgCqT1HKKWsnBMkRZkj1ZcOk+G30Wak+hiNzKDv7LEs
         cuvYYZUXqxW7GU0e10OkO9Aq6SQtMcVdptdRNZIWUakj+daM2IRmsiFg8vWgO+rwrAOb
         Hkq7HczS6hA9GYo7JNOSCdaDoCfnlPClNTbUiO4oVy6XulIt4MJSYWxFwpbdBZx0FvIL
         DByQ==
X-Gm-Message-State: ANoB5pkmRBuL4NG/7qOmjVCjmBo1JzWlYS2k+21/dSExsILi5zPCKFAE
        cZoDTqtzbWXbdtqay7GVedYHiJn3ZBbr2nzZ
X-Google-Smtp-Source: AA0mqf7ieizeGB/gx/xQISp1lWzt9RgP/eXwDAHP1a+Bnl1ff+QJK9r2V3rI6Sjy54jkjpz98SlnRQ==
X-Received: by 2002:a17:90b:3c0a:b0:213:7030:b2ec with SMTP id pb10-20020a17090b3c0a00b002137030b2ecmr46547928pjb.95.1669382018210;
        Fri, 25 Nov 2022 05:13:38 -0800 (PST)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902654600b00188fcc4fc00sm3362643pln.79.2022.11.25.05.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 05:13:37 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@meta.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
In-Reply-To: <20221125103412.1425305-1-dylany@meta.com>
References: <20221125103412.1425305-1-dylany@meta.com>
Subject: Re: (subset) [PATCH for-next 0/3] io_uring: completion cleanups
Message-Id: <166938201711.7977.7521431805922797296.b4-ty@kernel.dk>
Date:   Fri, 25 Nov 2022 06:13:37 -0700
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

On Fri, 25 Nov 2022 02:34:09 -0800, Dylan Yudaken wrote:
> A couple of tiny cleanups and 1 revert. I think the revert may be neater
> if you just drop it from your tree.
> 
> Patch 1: small cleanup removing a not-needed
> Patch 2: spelling fix
> Patch 3: I think I merged this badly, or at least misunderstood the recent
> changes. It was not needed, and confuses the _post suffix with also deferring.
> 
> [...]

Applied, thanks!

[1/3] io_uring: remove io_req_complete_post_tw
      commit: 27f35fe9096b183d45ff6f22ad277ddf107d8428
[2/3] io_uring: spelling fix
      commit: 10d8bc35416d9e83ffe9644478756281c7bd4f52

Best regards,
-- 
Jens Axboe


