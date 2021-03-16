Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B53133D7A8
	for <lists+io-uring@lfdr.de>; Tue, 16 Mar 2021 16:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhCPPeZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Mar 2021 11:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238155AbhCPPd7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Mar 2021 11:33:59 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99837C061756
        for <io-uring@vger.kernel.org>; Tue, 16 Mar 2021 08:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=p9+PuS1qkcz/Tze45p8IBSudQSlVQwB89X91zVzlRGE=; b=EgzbzRXv0lhXq2wvlLB7c275Ny
        cdvrys12KEwQrkU81Z68fSfChO3pZw96+YqG+eQoppsVFe6jUXzzXbpxWXUej9oeQsjSgkmYLPvPi
        qnBhbePKs84w2EtAIE6L7gt3hCYwIEn5uRYrqWhCApFdMRpcezo4FF2ZtvIT8XU1af9Jlw+Si5VXJ
        nBvFQy7nffTe4UxMd6ACgC59Wpro2Lmakr17GJtZkPyVWS+5CGQohTe/r9AaNbpbzAl6N0T/ZnBHg
        wd0ymZSIX4NInyD4Dn5i/3nl/0CdY7grKMOWEOSYs6zQgPTsLYtMTk7nNE2hVWZWZH8Iq1sPPFi+L
        clR75QLhUJdx2uPnGcdlw11431JQ9aKefsEdB1R5FY158YqFdh7PjAzo0BOBE7Yd7O50rsHCe9yIj
        jDs/Q1HzGEvmmfaaQLk+BoRWo0kM+p6TmrNq9xvdSC8GKuUNbjjbTKr1PgtADxyE01tQDbkxxFlFG
        QclhkPJRtCeWrtCCQC9nPzv5;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lMBha-0000jO-0A; Tue, 16 Mar 2021 15:33:46 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 0/2] send[msg]()/recv[msg]() fixes/improvements
Date:   Tue, 16 Mar 2021 16:33:25 +0100
Message-Id: <cover.1615908477.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

here're patches which fix linking of send[msg]()/recv[msg]() calls
and make sure io_uring_enter() never generate a SIGPIPE.

Stefan Metzmacher (2):
  io_uring: call req_set_fail_links() on short send[msg]()/recv[msg]()
    calls
  io_uring: imply MSG_NOSIGNAL for send[msg]()/recv[msg]() calls

 fs/io_uring.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

-- 
2.25.1

