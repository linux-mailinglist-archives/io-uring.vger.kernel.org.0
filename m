Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E8269FA60
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 18:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbjBVRsc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 12:48:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbjBVRsb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 12:48:31 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817DB1ABED
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 09:48:30 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id s8so3543911ilv.10
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 09:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1677088110;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yrNvhxWdNyxB2PbdnB1iZgKcUAnpphy+p8zznlDMC58=;
        b=01olBwYVtzjky980Eh87JNytuHNT/E3zQqlmAcmW+IFmXCBzlSr+0EGeHG5rjASVHi
         3u7mKv7/CGhhASv+0w+7BaT0eZjY/wmi1gRqzHgCqt8041k53Rv/J7kUjGop89pQj1rf
         vjVmRs1PAG/j0Sz01IHfCTgBV66DM8vOrnc8Udv0vfCEGQU1kzk+JgZPPWpsDN4EyWkp
         xTaZZbuwTLEhbUqXTSUFkTAkM+XNQnpF5xMkMwvePGBIwvmGu0QEPTm02J7qDDBj4V8w
         nM02INxVwzpLWnk3/Yw9obvUORqIPecksHLP4ou/VkyW1h7KyDLB1UnC+Efya+/fvUnq
         dBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677088110;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yrNvhxWdNyxB2PbdnB1iZgKcUAnpphy+p8zznlDMC58=;
        b=a9RhtuEftjjNtH1rf/ySlkDgayIqJtkZNrIfMEVE4RwJCo7b4ktdYgC+O/10FNMdBP
         Ve5IMv58zSl4b+La4QNfvtSFNo+1c5iERhR+UpKb0+G78cNn4dljLpP7yXVPyZTF+Sak
         313n3eGBh4gMg3vVurG8V0egWBixyprEp5/qIu1ixDaVWHOeG8ohbqM5UkznKD0ftBTx
         Ol1fGnHWQsWs5oaHFUbTUVPmwyVUjcVWRx1ZWJrm1Ay7XU2zVxSAY76Ll1X9Uqu17vag
         xyIDFSQ15LqmhjI/4YJYqn98KB4adVM4yyPhWQiL8QaUSJUGun7Yt/dvRbxbuhjggLK4
         x94w==
X-Gm-Message-State: AO0yUKX68gXtvkq5OazJkBvlxUBvV2DkzUQmRBE27hNSyXRE95fku6PK
        M/07HheG0otiN+v8Ekfy6N3419oLrhCKCJ90
X-Google-Smtp-Source: AK7set/YGdfoiojLXwIjZT+wsHoW8dX7Lh9c5F+5cjhKStwvntpv6YyDCG+B9V+UrqekljFQlZA0dQ==
X-Received: by 2002:a92:ca4f:0:b0:314:6968:ed8d with SMTP id q15-20020a92ca4f000000b003146968ed8dmr6366618ilo.3.1677088109798;
        Wed, 22 Feb 2023 09:48:29 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x8-20020a02ac88000000b003e44371702fsm508426jan.67.2023.02.22.09.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 09:48:29 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5f9ad0301949213230ad9000a8359d591aae615a.1677002255.git.asml.silence@gmail.com>
References: <5f9ad0301949213230ad9000a8359d591aae615a.1677002255.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next] io_uring: remove unused wq_list_merge
Message-Id: <167708810907.98463.5564835603870032571.b4-ty@kernel.dk>
Date:   Wed, 22 Feb 2023 10:48:29 -0700
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


On Wed, 22 Feb 2023 14:32:43 +0000, Pavel Begunkov wrote:
> There are no users of wq_list_merge, kill it.
> 
> 

Applied, thanks!

[1/1] io_uring: remove unused wq_list_merge
      commit: 9a1563d1720680bdc1d702486b7b73f51c079b32

Best regards,
-- 
Jens Axboe



