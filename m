Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77866140489
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 08:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgAQHmy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 02:42:54 -0500
Received: from mr85p00im-zteg06011501.me.com ([17.58.23.182]:34622 "EHLO
        mr85p00im-zteg06011501.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729138AbgAQHmy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 02:42:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1579246974;
        bh=JHKyiUXsT8lxcYFO4HVR6UFM6j0Bkd0hw7WtLuKpyXg=;
        h=Content-Type:Subject:From:Date:Message-Id:To;
        b=Lpjb7NT32OV62coQq8vY+/Kp4xwmFlM4wa+gjBz5v/k+aNO6SCEhBfkYiK+g67Fw4
         6ZEj1CrheWYcw1M6HKwWD+tpJe/EFoOKrY8A/rtDnV6JnVznvy+/KN/zhV8yX23Rh7
         BrbzDseldxmLNNitwrPGQ4sc4jyo7yXqwc6Mq0AagCEmYWsC+PZ9EIHio2b4ZEinGi
         hk+fqK8aTebxu30aA/f5WFwf79LiUllVMbuTX86n3vNaoduPC5T+/MDO4fCy/nRTU6
         HDDcYdnmw9+3eaB+Haw6Wz2IIyr2Qv+IH7tsHW6N3yjPeSihUDdO/Z9Esc5l9V/UzQ
         zgUzzVcN8cFfw==
Received: from dhcp.her (louloudi.phaistosnetworks.gr [139.91.200.222])
        by mr85p00im-zteg06011501.me.com (Postfix) with ESMTPSA id 41FF62A0A9D;
        Fri, 17 Jan 2020 07:42:53 +0000 (UTC)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [PATCH v2] io_uring: add support for probing opcodes
From:   Mark Papadakis <markuspapadakis@icloud.com>
In-Reply-To: <886e284c-4b1f-b90e-507e-05e5c74b9599@kernel.dk>
Date:   Fri, 17 Jan 2020 09:42:50 +0200
Cc:     io-uring <io-uring@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <76278FD6-7707-483E-ADDA-DF98A19F0860@icloud.com>
References: <886e284c-4b1f-b90e-507e-05e5c74b9599@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-16_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=846 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-2001170060
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I 've been thinking about this earlier.
I think the most realistic solution would be to have kind of =
website/page(libiouring.org?), which lists all SQE OPs, the kernel =
release that first implemented support for it, and (if necessary) notes =
about compatibility.

- There will be, hopefully, a lot more such OPS implemented in the =
future
- By having this list readily available, one can determine the lowest =
Linux Kernel release required(target) for a specific set of OPs they =
need for their program. If I want support for readv, writev, accept, and =
connect - say - then I should be able to quickly figure out that e.g 5.5 =
is the minimum LK release I must require
- Subtle issues may be discovered, or other such important specifics may =
be to be called out -- e.g readv works for < 5.5 for disk I/O but (e.g) =
"broken" for 5.4.3. This should be included in that table

Testing against specific SQE OPs support alone won't be enough, and it =
will likely also get convoluted fast.
liburing could provide a simple utility function that returns the =
(major, minor) LK release for convenience.

@markpapadakis=
