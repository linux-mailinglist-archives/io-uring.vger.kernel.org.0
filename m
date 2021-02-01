Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7760030B386
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 00:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhBAX12 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Mon, 1 Feb 2021 18:27:28 -0500
Received: from yourcmc.ru ([195.209.40.11]:52604 "EHLO yourcmc.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231328AbhBAX1R (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 1 Feb 2021 18:27:17 -0500
Received: from yourcmc.ru (localhost [127.0.0.1])
        by yourcmc.ru (Postfix) with ESMTP id 1D9C7FE0656
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 02:26:34 +0300 (MSK)
Received: from rainloop.yourcmc.ru (yourcmc.ru [195.209.40.11])
        by yourcmc.ru (Postfix) with ESMTPSA id E76C1FE00CB
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 02:26:33 +0300 (MSK)
MIME-Version: 1.0
Date:   Mon, 01 Feb 2021 23:26:33 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: RainLoop/1.14.0
From:   vitalif@yourcmc.ru
Message-ID: <cce8fb403b910f5878ae3df1945c8c32@yourcmc.ru>
Subject: Re: Multiple io_uring issues with sendmsg/recvmsg on loopback
 interfaces
To:     io-uring@vger.kernel.org
In-Reply-To: <93c582ba132c8fd9bf230c91d9b316b7@yourcmc.ru>
References: <93c582ba132c8fd9bf230c91d9b316b7@yourcmc.ru>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Never mind, that was my own bug :-))
