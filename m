Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897093B209A
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 20:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhFWSw0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 14:52:26 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:40826 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhFWSwZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 14:52:25 -0400
Received: from [173.237.58.148] (port=33334 helo=localhost)
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lw7ws-0008Gz-Ih; Wed, 23 Jun 2021 14:50:06 -0400
Date:   Wed, 23 Jun 2021 11:50:04 -0700
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Olivier Langlois <olivier@trillion01.com>
Message-Id: <cover.1624473200.git.olivier@trillion01.com>
Subject: [PATCH v2 0/2] Minor SQPOLL thread fix and improvement
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I have been investigated a deadlock situation in my io_uring usage where
the SQPOLL thread was going to sleep and my user threads were waiting
inside io_uring_enter() for completions.

https://github.com/axboe/liburing/issues/367

This patch serie is the result of my investigation.

Olivier Langlois (2):
  io_uring: Fix race condition when sqp thread goes to sleep
  io_uring: Create define to modify a SQPOLL parameter

 fs/io_uring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

-- 
2.32.0

