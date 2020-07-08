Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC829218E0F
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 19:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgGHRQV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 13:16:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23521 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgGHRQT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 13:16:19 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200708171615epoutp02ed58fe2ef7955d7c7f3e0a6b0fde563a~f1nFxtk1M0878008780epoutp02J
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 17:16:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200708171615epoutp02ed58fe2ef7955d7c7f3e0a6b0fde563a~f1nFxtk1M0878008780epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594228575;
        bh=iu/ByTAkPscUZqkPRdD0G0HENn78kuDflwBS0ALFh9U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UHQaxipWQTPNnbNSGiolWjWR6Fnj/0yvFbrUQFtT43aRnVnuSkQ5JYWWR/xPyk6b3
         SAwIECJnPMeTjdVZdVdfRxONnKih4KajVCaKgRTbyyCRlxMrqcMlCz/SrTvJdvJa9P
         OjkkBHfYs/e0buWqfPwZEeMJx2QMtPaZ9KkVKsWI=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200708171614epcas5p3d48257257ec9e6214c955dd30f1eec90~f1nElZ67u2341823418epcas5p3i;
        Wed,  8 Jul 2020 17:16:14 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A9.4B.09467.E5FF50F5; Thu,  9 Jul 2020 02:16:14 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200708164414epcas5p1ca20bcbd6e0d5756e3703b5ac5d00d3f~f1LIWnxNW3059430594epcas5p1M;
        Wed,  8 Jul 2020 16:44:14 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200708164414epsmtrp2f0745063e37c839cea2f95e423343b2f~f1LIVtmE21933219332epsmtrp2T;
        Wed,  8 Jul 2020 16:44:14 +0000 (GMT)
X-AuditID: b6c32a49-a29ff700000024fb-86-5f05ff5ec399
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        78.1F.08382.ED7F50F5; Thu,  9 Jul 2020 01:44:14 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200708164412epsmtip1435031d20639f772168f4826ecd15d23~f1LGGWCIP1586915869epsmtip1j;
        Wed,  8 Jul 2020 16:44:11 +0000 (GMT)
Date:   Wed, 8 Jul 2020 22:11:16 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        mb@lightnvm.io, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200708164116.GA26480@test-zns>
MIME-Version: 1.0
In-Reply-To: <20200708142251.GQ25523@casper.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xTZxjH855z2h4a686qxAcQL5WEy0IVcMtBcVTikgOJmTHBGBeBRk6g
        G5empVz2YelwyFanEEFGa8cIkXBxc1ltSmF0dqysdqwO0oiJo06xkKwyZFZYswqbp6cmfvs9
        /+f/vM8lL4lLfxckkqqaOlZTo6ySCcWE7af01MyS/wSl+0bOJdPmYRuir/nbhLRhw0rQLa1r
        GD3V3ofRyy23CfrRXEhEd3Y1I9px7w163OEhaN+YWUgPjrgI2hb5Cqcfhz1C+rd1t4COhM1C
        BcWMmvwi5sZgBuPz6hjL00si5vydMGIuWocRE7LsYFqd5zHGEvgLOxZ3SpxXzlap6lnN3rfL
        xJVD/WFCrZc29q2e1KOwxIBIEqj94HLnG1AcKaW+R+A4l2NA4hf8FMHjPx4J+GANwfWOEMG5
        uIIvIs5YwoGg55t2jA8WEXhNToxzEVQKeAZWMa6FkEqH6Q4dh1upNFiyZnN2nBrCofuTpeij
        W6jDEBr1IM4joTJhqXc7J0uo18FjDEQtcdQBGOscEXEcT+0Bp80dbQvUAxKMxiERP9wRcBsN
        Md4CQbc1xokQWnYIedbCv3OTOF/8KYK7emNss3yYGV+Pzo9TlWCLDGC8ngyXf7ke0zfDhUgg
        pkvA3vOSd8P9SwsCnrfBw+6rMWZg+p5bxN/3CQ5We1I72ml6ZTnTK+14PgCfrTQLTC9ugVNJ
        MLBB8pgO347t7UWCYZTAqrXVFaz2TXVWDdsg1yqrtbqaCvmZ2moLiv6/jEI78j9YkU8gjEQT
        CEhctlWyb7egVCopVzZ9yGpqSzW6KlY7gZJIQrZNIgv/WiKlKpR17Acsq2Y1L7MYGZeox1LW
        1ScUDQsf/ZD7znjLM9ufzLGCO2VLivqe3KnJ2enG0Wzz5bXQj8HimVrmtj3QD21fv/bs56yz
        cscF58J63mJqgcCMDjk3qfe7tyekJhQGi+tvTgXevdhonxZ1vtX/fllXwHI6vzFl1560ed/R
        eG/L800Fwdnkoo2FktTPB6rUqyitqU9V6XgyaNVlFbR3nUq/clLjWin/Eul3Wm33z9zK8HQd
        aZrN/Ft+WoEX9rY9z/NB7XflfsYVvKE6hLJbLQ/dETZ+vr6uIXf+5kHVrTZ02HNiznVw9OOO
        Qf/ZYn/3UXNRzq7NG3e9i+OiScdi8z9F4pnjy4qJ9xQ+b87xHTJCW6nMysA1WuX/otRWh+4D
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWy7bCSnO6976zxBrcXi1vMWbWN0WL13X42
        i65/W1gsWtu/MVmcnrCIyeJd6zkWi8d3PrNbTJnWxGix95a2xZ69J1ksLu+aw2axYvsRFott
        v+czW7z+cZLN4vzf46wWv3/MYXMQ8Ng56y67x+YVWh6Xz5Z6bPo0id2j++oPRo++LasYPT5v
        kvNoP9DN5LHpyVumAM4oLpuU1JzMstQifbsErowVbyYxFmzir/i4+w5jA+MR7i5GTg4JAROJ
        6b8PsHYxcnEICexmlJiwtpcFIiEu0XztBzuELSyx8t9zdoiiJ4wSb7fdYAJJsAioSJxc/hXI
        5uBgE9CUuDC5FMQUEdCQeLPFCKScWWAts8TZ/9OYQcqFBRwlPu88yQhSwyugK/FmgQxIWEjg
        PbPE12kqIDavgKDEyZlPwE5gFjCTmLf5ITNIObOAtMTyfxwgYU4BK4ldU7aDXSYqoCxxYNtx
        pgmMgrOQdM9C0j0LoXsBI/MqRsnUguLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzg2NPS3MG4
        fdUHvUOMTByMhxglOJiVRHgNFFnjhXhTEiurUovy44tKc1KLDzFKc7AoifPeKFwYJySQnliS
        mp2aWpBaBJNl4uCUamAqful78e1Rk9g3L6o2LD085fgXlotWKxYK3f8rpDB/Z/e2FXGZinNf
        mK/++OCV1JesTwfqyqo+K1jp7t3tJf18d/T6Fwe8/K4JW1SUBQhOWfDVwYdRcy5j9ORV3x9M
        PN+3KLngwXaHVc2l5/3+cu87FpHeXOnDds1Hzqnx476bpq2qlh/+WS87ZHXKN3jOVp6Iy+eW
        3Qr+9phdvv+5roFkaUp0XejTIldehVPeP+4u5P1d4JZ++g7DBdY9PzQ33ytTPrphP3+9ZZGn
        /tHXqqqeYc5PRdUUVW/EcApy2gedcUhJNwtMe1p0crp3luUbxqcX1tpZ2/6fueHPbD03ltIr
        GTIS79zYeG4deKWszfVBiaU4I9FQi7moOBEAtHknCCwDAAA=
X-CMS-MailID: 20200708164414epcas5p1ca20bcbd6e0d5756e3703b5ac5d00d3f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----FBC7EIImzEv-3WQrgwRbJYn4xAlwhlhWWV1zALX9mq8rjZSB=_e96fa_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20200707223803epcas5p41814360c764d6b5f67fdbf173a8ba64e
References: <20200706143208.GA25523@casper.infradead.org>
        <20200707151105.GA23395@test-zns>
        <20200707155237.GM25523@casper.infradead.org>
        <20200707202342.GA28364@test-zns>
        <7a44d9c6-bf7d-0666-fc29-32c3cba9d1d8@kernel.dk>
        <20200707221812.GN25523@casper.infradead.org>
        <CGME20200707223803epcas5p41814360c764d6b5f67fdbf173a8ba64e@epcas5p4.samsung.com>
        <145cc0ad-af86-2d6a-78b3-9ade007aae52@kernel.dk>
        <20200708125805.GA16495@test-zns>
        <20200708142251.GQ25523@casper.infradead.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------FBC7EIImzEv-3WQrgwRbJYn4xAlwhlhWWV1zALX9mq8rjZSB=_e96fa_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Wed, Jul 08, 2020 at 03:22:51PM +0100, Matthew Wilcox wrote:
>On Wed, Jul 08, 2020 at 06:28:05PM +0530, Kanchan Joshi wrote:
>> The last thing is about the flag used to trigger this processing. Will it be
>> fine to intoduce new flag (RWF_APPEND2 or RWF_APPEND_OFFSET)
>> instead of using RWF_APPEND?
>>
>> New flag will do what RWF_APPEND does and will also return the
>> written-location (and therefore expects pointer setup in application).
>
>I think it's simpler to understand if it's called RWF_INDIRECT_OFFSET
>Then it'd look like:
>
>+	rwf_t rwf = READ_ONCE(sqe->rw_flags);
>...
>-	iocb->ki_pos = READ_ONCE(sqe->off);
>+	if (rwf & RWF_INDIRECT_OFFSET) {
>+		loff_t __user *loffp = u64_to_user_ptr(sqe->addr2);
>+
>+		if (get_user(iocb->ki_pos, loffp)
>+			return -EFAULT;
>+		iocb->ki_loffp = loffp;
>+	} else {
>+		iocb->ki_pos = READ_ONCE(sqe->off);
>+	}
>...
>-	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
>+	ret = kiocb_set_rw_flags(kiocb, rwf);

It will sure go like this in io_uring, except I was thinking to use
io_kiocb rather than iocb for "loffp". 
I am fine with RWF_INDIRECT_OFFSET, but wondering - whether to build
this over base-behavior offered by RWF_APPEND.
This is what I mean in code (I used RWF_APPEND2 here)- 

static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
        ki->ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
        if (flags & RWF_APPEND)
                ki->ki_flags |= IOCB_APPEND;
+       if (flags & RWF_APPEND2) {
+               /*
+                * RWF_APPEND2 is "file-append + return write-location"
+                * Use IOCB_APPEND for file-append, and new IOCB_ZONE_APPEND
+                * to return where write landed
+                */
+               ki->ki_flags |= IOCB_APPEND;
+               if (ki->ki_filp->f_mode & FMODE_ZONE_APPEND) /*revisit the need*/
+                       ki->ki_flags |= IOCB_ZONE_APPEND;
+       }
+

------FBC7EIImzEv-3WQrgwRbJYn4xAlwhlhWWV1zALX9mq8rjZSB=_e96fa_
Content-Type: text/plain; charset="utf-8"


------FBC7EIImzEv-3WQrgwRbJYn4xAlwhlhWWV1zALX9mq8rjZSB=_e96fa_--
