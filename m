Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08AA75CB9D
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 17:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjGUPYr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 11:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjGUPYn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 11:24:43 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8086D30DB;
        Fri, 21 Jul 2023 08:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1689953074; x=1690557874; i=deller@gmx.de;
 bh=A7WxgBjz3zo2CGF0QZzRQfzfUsKrkF2oGa6/wHukdFM=;
 h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
 b=Ko2qdlYuXReozta8VnE/apNE4ymC4iZTiFxjjaTrWqbv3JfCPN118kMJWChmEnhlS24yB3N
 1t8V9dVHuKJxQQIEvdgeGzMphReVYqX3QZ3C0WvhfnYS7SKhc+sRPYJPIDHvStB1RxMlMfEOH
 ZcaBANg+jJmd6S1FLrcpEWyjCN2bIl7Sa+2i4ikkkomVs4U8C7szAvfiUxuihA+dxplk7o8F0
 Y0REMm9pz92bAWA+1qBDiEOTGAFQQtAqo7HwZS8KR2NL1ikeglPK9IQVkCywUGfYaP3VqPE6g
 vXgGkF28uQawUqqWZaqnzBFXmUajHZUGJuguXvdQ1THzu2ef6ODg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from p100.fritz.box ([94.134.144.189]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MplXp-1pZVPD1kfV-00q8gd; Fri, 21
 Jul 2023 17:24:34 +0200
From:   Helge Deller <deller@gmx.de>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-ia64@vger.kernel.org,
        Jiri Slaby <jirislaby@kernel.org>, linux-parisc@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>,
        matoro <matoro_mailinglist_kernel@matoro.tk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] ia64: mmap: Consider pgoff when searching for free mapping
Date:   Fri, 21 Jul 2023 17:24:32 +0200
Message-ID: <20230721152432.196382-3-deller@gmx.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721152432.196382-1-deller@gmx.de>
References: <20230721152432.196382-1-deller@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BplPTINVd0OdLsIUOtIgdkny/5qsRkSo0WcblPhJqu+oYHGcw71
 bySZIEIKmJcNLmjhb0oyHAQr7vH8bDvcfn3G9AiBlVHH66N8vx2stCFdAQ0FpCCx/6LRvup
 fNkM5mAgT11aCqfJH9ZXj7iiqcRE/77E62bTUUtTpZBy0aU9iR2eMAqkVpwUxqNvjTwas5V
 MOOSvn7rsNQyWiClPxdEw==
UI-OutboundReport: notjunk:1;M01:P0:AYbJDJWuZLQ=;AAsXgFhQ1l5zYV5mMqehdTP+Z69
 OK5Ws0ozn2VQuyZl3r6VhNTq190tOl0PsnFHiQo8EMfGxNF14Jeqq/NlM3oZsmJiWTmIiAtQM
 Cq4tK1VwMSsfTJGepWQgKeZqbMD98AaA30FoUvoLeyUe0APn0mykrO5eeWc3f58pcrNA/xbaA
 F6RN8Mn70+QFHMzOgqmNb3yzwpBNgjrGdkJm5fx6lnn1oPJUX9Uy2YJv8DqNxyvMJhGYrV4Xy
 fudinA+6wZ5BNMnyJuxoR+MLjfpkI1+HW76LGjPr1AC1VjmypYN0BigTDnCAr/nqbTSVaIOzV
 j6j4G5qmoISfY/fvPZr4tuca24UvOwBY0IrL0wRSnA+OrfOkAvkxNxjrmIpFOM63ZJi++mYuS
 0MYgIeCMpkH2XvKGY+WWxlkflD6i87susUQp19Lwi4PB165Ap7MNokr63eE/n2DwiIsc0x7Ey
 KOx9dRGzUkRINyL/FNtUSBV/646Pb9Lql5aQa2XaY0HcVs/wcDgLwx/uMTjQjHcR3eC+sd/6R
 /KTmSIACgxjHYdStmASVhBa42RdXxOF6daYUCimJ5iZD4bMrtG/nTPCx/cd67JZUSr2ah+BCE
 wo1j9j4IQ+5nO61nhzC9aN0Pfu6WAIFqLrI4rCA4SvIpIQl3cSVlm0eLKPZ2Q95RRMepx+WX4
 nW2jVZ9PIaLD3am2rpQKWd0lHxpPTlFQHy2pvwRmcBoi7K2XuH/XBONRZF7gFLnxZV0ifoA+Q
 2qmv6oSRNmXrTrMhlR4j8xCn+h4HwCBwPRAZBIMc/V1WMhPWlT6CpKU4ErjOWuUs5BfNEYUZ9
 ikmLLPIHkkWL55i93IKTiv9jkXTQrIq5mh19XnKVJpYNxAv71KYuJYcV312/IPpepC4CW8rsj
 kArwN2qAlQbBDUS9K7k+XvtCdiMv0W2nNDaizDkXthmsD1au7asBxLX/LAUxtNieo/moaxEIv
 SA90T0opNeszWvzo9N6wrK7IIh4=
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

IA64 is the only architecture which does not consider the pgoff value when
searching for a possible free memory region with vm_unmapped_area().
Adding this seems to have no negative side effect on IA64, so add it now
to make IA64 consistent with all other architectures.

Signed-off-by: Helge Deller <deller@gmx.de>
Tested-by: matoro <matoro_mailinglist_kernel@matoro.tk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-ia64@vger.kernel.org
=2D--
 arch/ia64/kernel/sys_ia64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/sys_ia64.c b/arch/ia64/kernel/sys_ia64.c
index 6e948d015332..eb561cc93632 100644
=2D-- a/arch/ia64/kernel/sys_ia64.c
+++ b/arch/ia64/kernel/sys_ia64.c
@@ -63,7 +63,7 @@ arch_get_unmapped_area (struct file *filp, unsigned long=
 addr, unsigned long len
 	info.low_limit =3D addr;
 	info.high_limit =3D TASK_SIZE;
 	info.align_mask =3D align_mask;
-	info.align_offset =3D 0;
+	info.align_offset =3D pgoff << PAGE_SHIFT;
 	return vm_unmapped_area(&info);
 }

=2D-
2.41.0

