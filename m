Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063ED30A911
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 14:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhBANuH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Mon, 1 Feb 2021 08:50:07 -0500
Received: from yourcmc.ru ([195.209.40.11]:39290 "EHLO yourcmc.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231587AbhBANuG (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 1 Feb 2021 08:50:06 -0500
X-Greylist: delayed 626 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Feb 2021 08:50:05 EST
Received: from yourcmc.ru (localhost [127.0.0.1])
        by yourcmc.ru (Postfix) with ESMTP id C363AFE0656
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 16:38:57 +0300 (MSK)
Received: from rainloop.yourcmc.ru (yourcmc.ru [195.209.40.11])
        by yourcmc.ru (Postfix) with ESMTPSA id 80F2FFE00CB
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 16:38:57 +0300 (MSK)
MIME-Version: 1.0
Date:   Mon, 01 Feb 2021 13:38:57 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: RainLoop/1.14.0
From:   vitalif@yourcmc.ru
Message-ID: <93c582ba132c8fd9bf230c91d9b316b7@yourcmc.ru>
Subject: Multiple io_uring issues with sendmsg/recvmsg on loopback
 interfaces
To:     io-uring@vger.kernel.org
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi

I'm having problems with io_uring when several applications communicate within localhost using sockets and io_uring.

I don't have a complete testcase yet, but the problem is apparently the following:
- on kernels 5.4 and 5.5 messages sent via io_uring sendmsg() and received via io_uring recvmsg() are SOMETIMES duplicated. 1 process sends 512 bytes and the second one receives the same message twice.
- in addition to that, on kernel 5.10 I often get garbage from io_uring recvmsg().

I discovered it when running a Vitastor (https://vitastor.io/) testcase, so it's not too easy to extract a minimal example for reproduction, and I can't be 100% sure that it's not my bug, however I know for sure that:
- on kernels 5.4 and 5.5 everything is fine when I disable io_uring sendmsg OR io_uring recvmsg and replace it with a classic synchronous version
- on kernel 5.10 everything is fine when I disable BOTH io_uring sendmsg and recvmsg
- everything was fine when I was testing my project in a setup with real networking instead of loopback

If you're really curious you can try to reproduce it yourself, you need to build Vitastor for it and then run ./run_tests.sh. The first issue manifests itself as a hang during `fio` run with 'command out of sync' message in one of ./testdata/osd*.log and the second one manifests as multiple failure messages during `fio` run with 'Received garbage: ' messages on one of ./testdata/osd*.log. Both issues reproduce almost every run.

I'll try to come back with a real test-case for reproduction, but maybe even this information can be sufficient for you to look at io_uring+sendmsg+recvmsg+loopback problems?

-- 
With best regards,
  Vitaliy Filippov
