Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5757A1437E3
	for <lists+io-uring@lfdr.de>; Tue, 21 Jan 2020 08:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgAUHu5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 02:50:57 -0500
Received: from mr85p00im-zteg06021901.me.com ([17.58.23.194]:37170 "EHLO
        mr85p00im-zteg06021901.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726052AbgAUHu5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 02:50:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1579593057;
        bh=n7vfXMRClMw4n+fIEJaetT2FJfeZ5VhDXZpEr2E1W7k=;
        h=From:Content-Type:Subject:Message-Id:Date:To;
        b=WlRS+koTCrknyYe47Pd/soj3b9KrKPco+896OMxVfELG+VrqD8u0vxMkN9jwYP8yp
         nnASjgn8/OWo0omVhz+tHIk4ikbpVSvrGfd7m9FjTElpEp5DHSGSDmdPPWiCOoqP/W
         TH00aQ0lcSqAMOZKNiP7fMv+E1X3/IW0ehZQFl4PE1/MY3BDL4S68pvWxU4UmuVdr9
         CNFPiEcMpmBVPKK81NCCfr9LGAZ21XKZzc3IoG8rLhwChMA2vsfKOwhFhUWtj+nsCk
         MF9gwJasuWCU+M5i6YU07G+vHSz6vLieXRGvY51NOIlY++TGNCegqMUgw1bm2thY0v
         bjmJDIkR4uGew==
Received: from [192.168.10.177] (louloudi.phaistosnetworks.gr [139.91.200.222])
        by mr85p00im-zteg06021901.me.com (Postfix) with ESMTPSA id 9754F7206D6
        for <io-uring@vger.kernel.org>; Tue, 21 Jan 2020 07:50:56 +0000 (UTC)
From:   Mark Papadakis <markuspapadakis@icloud.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Extending the functionality of some SQE OPs
Message-Id: <30608E23-1CE9-4830-BC95-8D57BCB4CCE8@icloud.com>
Date:   Tue, 21 Jan 2020 09:50:54 +0200
To:     io-uring <io-uring@vger.kernel.org>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-21_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=566 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-2001210068
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Would it make sense to extend the semantics of some OPS of specific =
syscalls to, for example, return in the CQE more than just an int =
(matching the semantics of the specific syscall they represent)?
For example, the respective OP for accept/accept4 returns an int for =
error or the fd of the accepted connection=E2=80=99s socket FD. But, =
given the clean-room implementation of io_uring, this may be a good =
opportunity to expand on it. Maybe there should be another field in the =
CQEs e.g
union {
	int i32;
	uint64_t u64;
	// whatever makes sense
} ret_ex;
Where the implementation of some OPs would access and set accordingly. =
For example, the OP for accept could set ret_ex.i32 to 1 if there are =
more outstanding FDs to be dequeued from the accepted connections queue, =
so that the application should accept again thereby draining it - as =
opposed to being woken up multiple times to do so. Other OPs may take =
advantage of this for other reasons.

Maybe it doesn=E2=80=99t make as much sense as I think it does, but if =
anything, it could become very useful down the road, once more =
syscalls(even OPs that are entirely new are not otherwise represent =
existing syscalls?) are implemented(invented?).=20

@markpapadakis

