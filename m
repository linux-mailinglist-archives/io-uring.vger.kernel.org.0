Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69AB0621AD0
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 18:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbiKHRg1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 12:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbiKHRg1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 12:36:27 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99137E0D3
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 09:36:26 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id o13so7820904ilc.7
        for <io-uring@vger.kernel.org>; Tue, 08 Nov 2022 09:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8RxUnSFYpeEqMwnDI4N4U6Z98qAiiNyU8tVv+w7JlHU=;
        b=2W0HBMd4IBk2FkrKiKt1ddXHkfcpzcsxPRvIiNWlcsDpEewdqwIRohZqxZ8lwMEN6w
         h+ABNZtdG0wQ+fDmIa+iggbtlg90YB5cBGbd0+dK97H68Tx1rr2aYmo6dHinhxqZpJU/
         Qnoi21P2MQ40+47eO1wUIq8Y+Cx6zrVfjj2/kVyg9pBksi71WesFs85eGJquYvMcX/Zm
         2zQumozPo5FTmIi89kd2QnESSOX1FxpqEoBIPDb3Kem6Zn+AjgreePGAPzPhYesD7JBa
         uY0N3kIR0GM1/zqvdiluNFKilb957qZBiX7qKLz5VEYx6ASigeziRxZC3b37oas30X28
         Sjqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8RxUnSFYpeEqMwnDI4N4U6Z98qAiiNyU8tVv+w7JlHU=;
        b=ch04vwQ5L3AEb9cXZVyeiN3Ss2wKukAKTssXMxx7N0dvqNmYTXkpGnzT4l+JfSTC8H
         /8xilw3pQ+6b4lckNnbxHaI1iuaaH5foOdIQ341L6vpYZ8TNN1+lA8KAziLG7Eu7VRfu
         WqGDJpoh42KGBUaFaLDfL8LEtwnYJvdoaBf3ZVdXCJXJkWQevmcxR3lrJwK7D6xHcEGW
         lDIxmMTmBBDrwg3cvJtts1Bc4M92AUwxSuNQfqqwtL9u+qgoQfIi8LWusvjpl0+a++Uv
         EZYjyDQxm3eeETQ0pvol2onVOK+robMRjgydNtBUWtAOgbygFjaDSxYQ3F7qmOEysoj/
         UhAg==
X-Gm-Message-State: ACrzQf0xuYln/NkzAvpfYiJ6vwFuRk4ozE2r4ilQpuqpJ/5sKFGN7D1Y
        UuP6xKaOYcWmDcbMj4TbPgLOIon6Qb+jZ+tq
X-Google-Smtp-Source: AMsMyM4RqzpGZ6AhHRgnOb6bvwFjRxHEx6Qs0D+pjAgd1aVyOWu9qYmfaQOGsHknzEmF3AyzAFHshw==
X-Received: by 2002:a92:7c10:0:b0:300:e321:c20f with SMTP id x16-20020a927c10000000b00300e321c20fmr14606802ilc.168.1667928985740;
        Tue, 08 Nov 2022 09:36:25 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i12-20020a056638380c00b00363c68aa348sm3897795jav.72.2022.11.08.09.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 09:36:25 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
In-Reply-To: <20221108153016.1854297-1-dylany@meta.com>
References: <20221108153016.1854297-1-dylany@meta.com>
Subject: Re: [PATCH] io_uring: calculate CQEs from the user visible value
Message-Id: <166792898495.7775.5557058667530205270.b4-ty@kernel.dk>
Date:   Tue, 08 Nov 2022 10:36:24 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 8 Nov 2022 07:30:16 -0800, Dylan Yudaken wrote:
> io_cqring_wait (and it's wake function io_has_work) used cached_cq_tail in
> order to calculate the number of CQEs. cached_cq_tail is set strictly
> before the user visible rings->cq.tail
> 
> However as far as userspace is concerned,  if io_uring_enter(2) is called
> with a minimum number of events, they will verify by checking
> rings->cq.tail.
> 
> [...]

Applied, thanks!

[1/1] io_uring: calculate CQEs from the user visible value
      commit: 0fc8c2acbfc789a977a50a4a9812a8e4b37958ce

Best regards,
-- 
Jens Axboe


