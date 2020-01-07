Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81C9B132A95
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2020 17:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgAGQAN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jan 2020 11:00:13 -0500
Received: from mr85p00im-ztdg06011801.me.com ([17.58.23.199]:46357 "EHLO
        mr85p00im-ztdg06011801.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727974AbgAGQAN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jan 2020 11:00:13 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jan 2020 11:00:13 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1578412510;
        bh=4+NRPIXioapR/C/ukFQWhjHYZ3q91zMOMY5bmZRwe+w=;
        h=From:Content-Type:Subject:Message-Id:Date:To;
        b=qDPlar2QddQOsazX4pCspNH4H5jCwcf3fOk//MJuCuIH1iLcW/dqGaoN1pRLXWT3/
         OmIU5zI1JwfPrQSui+KiZ5eodPcQMnxBN8BUSj06R4HMJMIOAcG5EPYddNW2oS7SIz
         tcn86nmUrTLgEiQpY3zmoetrHpg4+ggwY6VATKpeTkImi1QR1V7Kvb8RXJHF680QlN
         hYf1AjDuGfX7u6QO4tYEqY2aKxIlleLnMY6HPGkZkBxwN76+xRtCo5DDk0G2SA2mIx
         7ddN6LE3AfBupCOLGCQJ7KmEhIKnxsQkUmZ/4fxq+HDM4Bt4ZDlw93C2WQ/lxKYNiC
         S2bZaLLC2qAkw==
Received: from [192.168.10.177] (louloudi.phaistosnetworks.gr [139.91.200.222])
        by mr85p00im-ztdg06011801.me.com (Postfix) with ESMTPSA id 5D021C1168
        for <io-uring@vger.kernel.org>; Tue,  7 Jan 2020 15:55:09 +0000 (UTC)
From:   Mark Papadakis <markuspapadakis@icloud.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: io_uring and spurious wake-ups from eventfd
Message-Id: <2005CB9A-0883-4C35-B975-1931C3640AA1@icloud.com>
Date:   Tue, 7 Jan 2020 17:55:31 +0200
To:     io-uring@vger.kernel.org
X-Mailer: Apple Mail (2.3601.0.10)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-07_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=721 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-2001070132
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is perhaps an odd request, but if it=E2=80=99s trivial to implement =
support for this described feature, it could help others like it =E2=80=98=
d help me (I =E2=80=98ve been experimenting with io_uring for some time =
now).

Being able to register an eventfd with an io_uring context is very =
handy, if you e.g have some sort of reactor thread multiplexing I/O =
using epoll etc, where you want to be notified when there are pending =
CQEs to drain. The problem, such as it is, is that this can result in =
un-necessary/spurious wake-ups.

If, for example, you are monitoring some sockets for EPOLLIN, and when =
poll says you have pending bytes to read from their sockets, and said =
sockets are non-blocking, and for each some reported event you reserve =
an SQE for preadv() to read that data and then you io_uring_enter to =
submit the SQEs, because the data is readily available, as soon as =
io_uring_enter returns, you will have your completions available - which =
you can process.
The =E2=80=9Cproblem=E2=80=9D is that poll will wake up immediately =
thereafter in the next reactor loop iteration because eventfd was =
tripped (which is reasonable but un-necessary).

What if there was a flag for io_uring_setup() so that the eventfd would =
only be tripped for CQEs that were processed asynchronously, or, if =
that=E2=80=99s non-trivial, only for CQEs that reference file FDs?

That=E2=80=99d help with that spurious wake-up.

Thank you,
@markpapadakis=
