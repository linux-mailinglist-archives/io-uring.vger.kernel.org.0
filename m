Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505891E97B4
	for <lists+io-uring@lfdr.de>; Sun, 31 May 2020 14:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgEaMrm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 May 2020 08:47:42 -0400
Received: from bonobo.birch.relay.mailchannels.net ([23.83.209.22]:11858 "EHLO
        bonobo.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725889AbgEaMrm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 May 2020 08:47:42 -0400
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 5CFAB340AD2
        for <io-uring@vger.kernel.org>; Sun, 31 May 2020 12:47:41 +0000 (UTC)
Received: from pdx1-sub0-mail-a27.g.dreamhost.com (100-96-137-10.trex.outbound.svc.cluster.local [100.96.137.10])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id BEBE6341054
        for <io-uring@vger.kernel.org>; Sun, 31 May 2020 12:47:40 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a27.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.8);
        Sun, 31 May 2020 12:47:41 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Absorbed-Stupid: 751188e22a94e3c3_1590929260992_1473583181
X-MC-Loop-Signature: 1590929260992:3259203027
X-MC-Ingress-Time: 1590929260991
Received: from pdx1-sub0-mail-a27.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a27.g.dreamhost.com (Postfix) with ESMTP id 6A6EC80248
        for <io-uring@vger.kernel.org>; Sun, 31 May 2020 05:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=claycon.org; h=date:from
        :to:subject:message-id:mime-version:content-type; s=claycon.org;
         bh=j0lJLFbWDPDK9q3ISb93xOBYPic=; b=TnlMgK9AjJ4bFOCMiaxkVt4NdEd+
        2Fa6t6KxRxZ04skd96EE3LiRIVUUFEQ6sDtcaiNl/SWHskICU6roCJEPeIDR4Jma
        efA/wA+lmilePnOzl0VWSROGSoyVA6ktbVWH0cEJzn//sWJPBPZk4+GnwgBfhNpF
        T8IcpnzoGQ48LdM=
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a27.g.dreamhost.com (Postfix) with ESMTPSA id 30560801AF
        for <io-uring@vger.kernel.org>; Sun, 31 May 2020 05:47:40 -0700 (PDT)
Date:   Sun, 31 May 2020 07:47:40 -0500
X-DH-BACKEND: pdx1-sub0-mail-a27
From:   Clay Harris <bugs@claycon.org>
To:     io-uring@vger.kernel.org
Subject: IORING_OP_CLOSE fails on fd opened with O_PATH
Message-ID: <20200531124740.vbvc6ms7kzw447t2@ps29521.dreamhostps.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 0
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrudeffedgheefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkgggtuggfsehttdertddtredvnecuhfhrohhmpeevlhgrhicujfgrrhhrihhsuceosghughhssegtlhgrhigtohhnrdhorhhgqeenucggtffrrghtthgvrhhnpeeufedvieejudekveekgeekffdtvedufedtkeffffduudeitdduleefudegffdujeenucfkphepieelrdduieefrddukeeirdejgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehpshdvleehvddurdgurhgvrghmhhhoshhtphhsrdgtohhmpdhinhgvthepieelrdduieefrddukeeirdejgedprhgvthhurhhnqdhprghthhepvehlrgihucfjrghrrhhishcuoegsuhhgshestghlrgihtghonhdrohhrgheqpdhmrghilhhfrhhomhepsghughhssegtlhgrhigtohhnrdhorhhgpdhnrhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Tested on kernel 5.6.14

$ ./closetest closetest.c

path closetest.c open on fd 3 with O_RDONLY
 ---- io_uring close(3)
 ---- ordinary close(3)
ordinary close(3) failed, errno 9: Bad file descriptor


$ ./closetest closetest.c opath

path closetest.c open on fd 3 with O_PATH
 ---- io_uring close(3)
io_uring close() failed, errno 9: Bad file descriptor
 ---- ordinary close(3)
ordinary close(3) returned 0
