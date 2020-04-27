Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495471BA929
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 17:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgD0PuY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 11:50:24 -0400
Received: from azure.elm.relay.mailchannels.net ([23.83.212.7]:60926 "EHLO
        azure.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727073AbgD0PuX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 11:50:23 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Apr 2020 11:50:22 EDT
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 8621B641586
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 15:43:17 +0000 (UTC)
Received: from pdx1-sub0-mail-a84.g.dreamhost.com (100-96-9-22.trex.outbound.svc.cluster.local [100.96.9.22])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 12AE5641927
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 15:43:17 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a84.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.6);
        Mon, 27 Apr 2020 15:43:17 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Society-Bottle: 42e1836222d56a9f_1588002197307_704073597
X-MC-Loop-Signature: 1588002197307:159093242
X-MC-Ingress-Time: 1588002197307
Received: from pdx1-sub0-mail-a84.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a84.g.dreamhost.com (Postfix) with ESMTP id C202D7F0A2
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 08:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=claycon.org; h=date:from
        :to:subject:message-id:mime-version:content-type; s=claycon.org;
         bh=gnYu2MhUJRFO3kFu3oRq3w51Zxg=; b=iJu+7gTmHa7I0PuporBXvfivD3hJ
        cfMgACPOEuuAqfSmqtBNde/4VOHkY5eoHXXgQYSupEuY56vcLrzH8lUDLQHnVFms
        Q0xiTtb2vtyn+J2RKPVtpqmsDoKNxrRxdZphN23YGKRXVV0X2ZO6/NsbaTkN9nVk
        9HLGdga0nag7N4Q=
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a84.g.dreamhost.com (Postfix) with ESMTPSA id 686437E62E
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 08:43:16 -0700 (PDT)
Date:   Mon, 27 Apr 2020 10:43:16 -0500
X-DH-BACKEND: pdx1-sub0-mail-a84
From:   Clay Harris <bugs@claycon.org>
To:     io-uring@vger.kernel.org
Subject: io_uring IORING_OP_POLL_ADD fails when fd is a tty
Message-ID: <20200427154316.vfh4z22cffx5oxvk@ps29521.dreamhostps.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 0
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdeltdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfggtggufgesthdtredttdervdenucfhrhhomhepvehlrgihucfjrghrrhhishcuoegsuhhgshestghlrgihtghonhdrohhrgheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepieelrdduieefrddukeeirdejgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehpshdvleehvddurdgurhgvrghmhhhoshhtphhsrdgtohhmpdhinhgvthepieelrdduieefrddukeeirdejgedprhgvthhurhhnqdhprghthhepvehlrgihucfjrghrrhhishcuoegsuhhgshestghlrgihtghonhdrohhrgheqpdhmrghilhhfrhhomhepsghughhssegtlhgrhigtohhnrdhorhhgpdhnrhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207461

Related link:
https://lore.kernel.org/io-uring/20200212202515.15299-1-axboe@kernel.dk/
