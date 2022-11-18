Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B020E62FF2A
	for <lists+io-uring@lfdr.de>; Fri, 18 Nov 2022 22:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiKRVIp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Nov 2022 16:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiKRVIn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Nov 2022 16:08:43 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AD113EA1
        for <io-uring@vger.kernel.org>; Fri, 18 Nov 2022 13:08:41 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id o13so3120811ilc.7
        for <io-uring@vger.kernel.org>; Fri, 18 Nov 2022 13:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WX5vpbQBtjN3WPC7oKkqZKVQt5je7AXbSXSQn0evje4=;
        b=E4kPUrs3M4S/d/UYAjYJ3dKEDyljZ/dXCmH6M/X4OyCl4pmLxkjJgflumWvUYnv0ai
         KF5Dhrgst3y+QfYKDaXvYFRtFEjm0E3jPLz0078mBh+9BULxcMTW+aajSWYjHrJebBGa
         LZ5XIYXmDQ7XQN1+h6OrSTB+XLgHoqFGAI8OIkUKa9ovc2SmhFcsV221WLBPtr+GSZ9a
         2LnaHBMuvH9NjAufV+nNolQaQKzi6FnjLlncKXV/N/U6DjKoznTVsXn+eM3KYRem0LDe
         uHgajDf4vV7dWsfr8hqrZ5Z/A80gijDj2CrOwMurKn1qH84jEGezDiKPLrmaYfvWRe04
         No2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WX5vpbQBtjN3WPC7oKkqZKVQt5je7AXbSXSQn0evje4=;
        b=tn6DS1rHky4cTvQXb7NRkf8ErGA+M5tOXKO6WBkf0Rhw3yOVMvBebzbnkVXSP/GHS6
         V8p54biu1U6T1yVSi62RCD2QB6DcVAszeLVUA5skc9dnbCGgKGLVC5gWqVfGloEN/osB
         Fnn2WCJUYqWOmg5gpjxOhkrIZuR1WM3QKSms3KYcCnY2ImBzkN39Ukjz52RjQkcr3mFo
         0uqiQS8Js4mIVOrJnd+AODbyWlH+M10XOi9aMRSQmkaS8eJPe8cczDGvR+VOKq+nEK4u
         lxAmYiBI5VM203Ra8EsYKDSvriOooubRbNyds9V2savlEFTrzM7EUtJ+M2ee16hT+Bcg
         VIUg==
X-Gm-Message-State: ANoB5pnPAqaKC07WBmgNI4IcY8+/pD2PyY04zpPxaP+i9+yH0GNXbWD/
        f8nE3J84suWOuiCmym85/A0Yhw==
X-Google-Smtp-Source: AA0mqf5l3gN5PJlfXVi7ME0i2EA9cG0kW078MKPmID1V+/Uch+RRva7jeYTd/3ZaD2EldZGIWdLYcg==
X-Received: by 2002:a92:d03:0:b0:302:988e:4ea7 with SMTP id 3-20020a920d03000000b00302988e4ea7mr3992925iln.224.1668805721058;
        Fri, 18 Nov 2022 13:08:41 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h10-20020a02c72a000000b00363fbcad265sm1586170jao.25.2022.11.18.13.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 13:08:40 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Lin Horse <kylin.formalin@gmail.com>
In-Reply-To: <394b02d5ebf9d3f8ec0428bb512e6a8cd4a69d0f.1668802389.git.asml.silence@gmail.com>
References: <394b02d5ebf9d3f8ec0428bb512e6a8cd4a69d0f.1668802389.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-6.1 v2] io_uring: make poll refs more robust
Message-Id: <166880572013.94530.4234904740779650209.b4-ty@kernel.dk>
Date:   Fri, 18 Nov 2022 14:08:40 -0700
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

On Fri, 18 Nov 2022 20:20:29 +0000, Pavel Begunkov wrote:
> poll_refs carry two functions, the first is ownership over the request.
> The second is notifying the io_poll_check_events() that there was an
> event but wake up couldn't grab the ownership, so io_poll_check_events()
> should retry.
> 
> We want to make poll_refs more robust against overflows. Instead of
> always incrementing it, which covers two purposes with one atomic, check
> if poll_refs is large and if so set a retry flag without attempts to
> grab ownership. The gap between the bias check and following atomics may
> seem racy, but we don't need it to be strict. Moreover there might only
> be maximum 4 parallel updates: by the first and the second poll entries,
> __io_arm_poll_handler() and cancellation. From those four, only poll wake
> ups may be executed multiple times, but they're protected by a spin.
> 
> [...]

Applied, thanks!

[1/1] io_uring: make poll refs more robust
      (no commit info)

Best regards,
-- 
Jens Axboe


