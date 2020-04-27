Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1289F1BA81B
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 17:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgD0PiD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 11:38:03 -0400
Received: from crocodile.birch.relay.mailchannels.net ([23.83.209.45]:39044
        "EHLO crocodile.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728032AbgD0PiD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 11:38:03 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Apr 2020 11:38:02 EDT
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 269514011C8
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 15:29:44 +0000 (UTC)
Received: from pdx1-sub0-mail-a84.g.dreamhost.com (100-96-14-18.trex.outbound.svc.cluster.local [100.96.14.18])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id A5E8E4004B9
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 15:29:43 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a84.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.6);
        Mon, 27 Apr 2020 15:29:44 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Chief-Skirt: 2926d22763aab07e_1588001383902_2093208734
X-MC-Loop-Signature: 1588001383902:2796293541
X-MC-Ingress-Time: 1588001383901
Received: from pdx1-sub0-mail-a84.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a84.g.dreamhost.com (Postfix) with ESMTP id 4347E7F0D5
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 08:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=claycon.org; h=date:from
        :to:subject:message-id:mime-version:content-type; s=claycon.org;
         bh=AfvyN1WV54scVpnMyhOp6g/a65w=; b=BpsNofR8Pc9A/g/Ir6m61glkvYXL
        ownKR1wFZ0/aK2Su8eVjrTVRC73DA99AVA1cegx845u2Z0a/q7ILGVFxVBUPV/nq
        fUvqSdN+SZgFx5nBQ8a2g5CjnWH4ucvnD/k8UM8GnCsdm4+okM0+EQBBG7QvC2I1
        2CnIg6Jsn/SXC94=
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a84.g.dreamhost.com (Postfix) with ESMTPSA id F23467F0BF
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 08:29:42 -0700 (PDT)
Date:   Mon, 27 Apr 2020 10:29:43 -0500
X-DH-BACKEND: pdx1-sub0-mail-a84
From:   Clay Harris <bugs@claycon.org>
To:     io-uring@vger.kernel.org
Subject: io_uring statx fails with AT_EMPTY_PATH 
Message-ID: <20200427152942.zhe6ncun7ijpbffq@ps29521.dreamhostps.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 0
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfggtggufgesthdtredttdervdenucfhrhhomhepvehlrgihucfjrghrrhhishcuoegsuhhgshestghlrgihtghonhdrohhrgheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepieelrdduieefrddukeeirdejgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehpshdvleehvddurdgurhgvrghmhhhoshhtphhsrdgtohhmpdhinhgvthepieelrdduieefrddukeeirdejgedprhgvthhurhhnqdhprghthhepvehlrgihucfjrghrrhhishcuoegsuhhgshestghlrgihtghonhdrohhrgheqpdhmrghilhhfrhhomhepsghughhssegtlhgrhigtohhnrdhorhhgpdhnrhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe recommended that I post io_uring stuff to this list.
So, here goes.

https://bugzilla.kernel.org/show_bug.cgi?id=207453
