Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7D575CB99
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 17:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjGUPYr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 11:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjGUPYm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 11:24:42 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B3030E8;
        Fri, 21 Jul 2023 08:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1689953073; x=1690557873; i=deller@gmx.de;
 bh=Bma+M1sMIhrZ2XEr1uAufjvTaxAHToWtl3NVzIYXa14=;
 h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
 b=oVhFyvUfT3uKdLtDPb/xewr3NQYeXfeepkV2ODHtc7LQBg3kiO72Gdeyn99D3xtttxlsEIn
 RXR9KDeJxhb8ZXFCmy1qzikGuXHX51Vsm3GuPm1VRQqvExCIINF+x/Z6NYlPNvGZsWtc5V+nR
 Yz6voEMzMOiO7pvSpvir9Y39QfTc/aV2yNr6cqPO2goGtXDIMM18kWnnJ1NSmzupb/vMJlfad
 jtq1lGHuyjKTbH5TJw2/Mh819aBoYvI11P6+zd6kfVEU7/Dy7KaZk85rRYuqBVVNqpyn8s2Q2
 5p9cwwlTBGzSVRq0dVNdBOvlcoTJX4SDtmIJXH0hhJHqfpjcWsrg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from p100.fritz.box ([94.134.144.189]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MWRRT-1qOqs61Bkp-00Xv0v; Fri, 21
 Jul 2023 17:24:33 +0200
From:   Helge Deller <deller@gmx.de>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-ia64@vger.kernel.org,
        Jiri Slaby <jirislaby@kernel.org>, linux-parisc@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>
Subject: [PATCH 0/2] io_uring: Fix io_uring mmap() by using architecture-provided get_unmapped_area()
Date:   Fri, 21 Jul 2023 17:24:30 +0200
Message-ID: <20230721152432.196382-1-deller@gmx.de>
X-Mailer: git-send-email 2.41.0
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:NttXxibtAeucS18W4DNkMGqpnfrGeyUL6TqcRVGZWPnjHRif9sk
 lGDv5x+6kVU7tYASYgAtzlvgJ6nImaILqna9eaG0bOF7FgDzT36hhyVYHxsNShvlN2inWtz
 IKSewL2y57kFjTtGLBjQP33KsfvhlBnjb5bBR14V3UXFholJ5CbnL5UIGXolsxZrIrzEara
 AdwdLnnPzt1d9FHERWuSg==
UI-OutboundReport: notjunk:1;M01:P0:NBgUUTAtUHg=;qYdow01HRHzQATzICMLdnVy7+Ig
 qOdbUudPJO+YOv9vl3aYmBelg7/QA+dtblyEFdZhOhhvr4TFTibPba26oLj+1xAv2NqUpvBZq
 cwbFhEkVBQ3u/xrzuURxOHmxvvosd8X1tvMFUq4TAjvsiMWcfR62HT9k7PDxq0yq4m64ruwfW
 DtYWBfg7euON5vfRG17HwjN7MyE/jbA3u/LGHnsaoxNhwI+14l6Maz2JLn+Xcch4+bcDySZOT
 XkcUA6Ua8rQ5rOhGR5ZZ4nM+P+T1BZKOEO+5LYt0wfhF/MaJrsJJ/GRzCeF5m3y3MJ1fO4Cuj
 9LG+9bQSKEU9NUDZ+dDeHIb5lIjpZFD1aeFYmeosmMoDDVltBCIkMQqHHccxI89zgbb1xYRwT
 VRbv8frPM8FhWCYu3B9aPzOB3yM6YDIrZ+r1TEbi4ZMkqtS2BuBDO/uKP9gWXv7gA2p+YqTAj
 Vmx+pZU0S0RbzD5dV92QYb6u4nJyPWetwbrcJXQVvk/DASHUxk3J5Ns35JiVMvnWuPE1J191v
 RPB+OrPq1Z8g6xgvA8fqVOizbql458Ts6cm2S+Jn27r/k+N4pGaSi6ADFC3G/0IRUoeBU0Gi7
 4i2Z9loaPFuEUGnqwef7Vz8mCX2RJ5/c1sNDKnkyYWs8teZpxHHqwyqs3EjvfYVpgNuf5HdU3
 n6vJ2q7weUL+FZWrnT+Ke4VNJJqNwqC7GPdCU6bLTWORAy9oiVS/VcZtupcAST8cz2iKUiYDs
 jZtDjHw9bUvJZqub90jb0u8IfLWza0/li2a23oZjLNWB3KfYzbHCnzdcJ1bZrO8SKnhCWdqrL
 S6y3+5+VTxXqGJoyK0SP1VandvDBkPJGJ1dMCxupQRXlN5AdFCXa8Diw5y4+liFZC+HMUKGGD
 VIK/78Tqup0rPy8Ed5SmN8HdbKG6INPxmqSqZo/Dud+BcRD3kZDuD6KF7flwJVQBMrf/HGs4y
 B35vWfi53ORsP8aXqBjMa6wmvYU=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fix io_uring on IA64 (and x86-32?) which was broken since commit
d808459b2e31 ("io_uring: Adjust mapping wrt architecture aliasing
requirements").
The fix is to switch back to the get_unmapped_area() which is provided by
each architecture.

Patch 1 switches io_uring back to use per-arch get_unmapped_area().
Patch 2 (for IA64) is an independend cleanup.

Helge

Helge Deller (2):
  io_uring: Fix io_uring mmap() by using architecture-provided
    get_unmapped_area()
  ia64: mmap: Consider pgoff when searching for free mapping

 arch/ia64/kernel/sys_ia64.c     |  2 +-
 arch/parisc/kernel/sys_parisc.c | 15 ++++++++----
 io_uring/io_uring.c             | 42 +++++++++++++--------------------
 3 files changed, 28 insertions(+), 31 deletions(-)

=2D-
2.41.0

