Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29FC1BA831
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 17:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgD0Pkh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 11:40:37 -0400
Received: from crocodile.birch.relay.mailchannels.net ([23.83.209.45]:7905
        "EHLO crocodile.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727022AbgD0Pkg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 11:40:36 -0400
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 133C3100E48
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 15:40:35 +0000 (UTC)
Received: from pdx1-sub0-mail-a84.g.dreamhost.com (100-96-12-30.trex.outbound.svc.cluster.local [100.96.12.30])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id A56D11017E3
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 15:40:34 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a84.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.6);
        Mon, 27 Apr 2020 15:40:35 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Illegal-Hook: 6ed2c0457e504504_1588002034891_2188239618
X-MC-Loop-Signature: 1588002034891:4122617455
X-MC-Ingress-Time: 1588002034891
Received: from pdx1-sub0-mail-a84.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a84.g.dreamhost.com (Postfix) with ESMTP id 82BF47F0D8
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 08:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=claycon.org; h=date:from
        :to:subject:message-id:mime-version:content-type; s=claycon.org;
         bh=ewHNTAoFgKORI75b6lVMJg1g4MI=; b=impA4f4QIsuptxUcoZ4BsE0E0fZA
        MbNJ9T6UFtNtdADOCd+YKs5zkwQlB9tn78z/LLFs+f5oGJa69x0Bt2PVnRqZiSXD
        fxYtH5EoehJGhEdnNuwNBRel2WNVLsdxTV7bpSMRbQcrOEFT/GjuWPJ0OJKrdG0d
        COaRXSFiJvhuO/E=
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a84.g.dreamhost.com (Postfix) with ESMTPSA id 43FC97F0A2
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 08:40:32 -0700 (PDT)
Date:   Mon, 27 Apr 2020 10:40:32 -0500
X-DH-BACKEND: pdx1-sub0-mail-a84
From:   Clay Harris <bugs@claycon.org>
To:     io-uring@vger.kernel.org
Subject: Feature request: Please implement IORING_OP_TEE 
Message-ID: <20200427154031.n354uscqosf76p5z@ps29521.dreamhostps.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 0
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdeltdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfggtggufgesthdtredttdervdenucfhrhhomhepvehlrgihucfjrghrrhhishcuoegsuhhgshestghlrgihtghonhdrohhrgheqnecukfhppeeiledrudeifedrudekiedrjeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhppdhhvghlohepphhsvdelhedvuddrughrvggrmhhhohhsthhpshdrtghomhdpihhnvghtpeeiledrudeifedrudekiedrjeegpdhrvghtuhhrnhdqphgrthhhpeevlhgrhicujfgrrhhrihhsuceosghughhssegtlhgrhigtohhnrdhorhhgqedpmhgrihhlfhhrohhmpegsuhhgshestghlrgihtghonhdrohhrghdpnhhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I was excited to see IORING_OP_SPLICE go in, but disappointed that tee
didn't go in at the same time.  It would be very useful to copy pipe
buffers in an async program.
