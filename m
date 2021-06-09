Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12D23A12D6
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 13:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238658AbhFILiH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 07:38:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38302 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbhFILiG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 07:38:06 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210609113610epoutp02a9fbed69fa521e62454e4b1e6be23684~G5uEPoAxz0063400634epoutp02K
        for <io-uring@vger.kernel.org>; Wed,  9 Jun 2021 11:36:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210609113610epoutp02a9fbed69fa521e62454e4b1e6be23684~G5uEPoAxz0063400634epoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623238570;
        bh=VCC1ocTa+pfE1YBQEhmF6TG5sDdJYTYPM8fYYtuGelk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=X9dFWGYjoufBBZKpcLBRjKFVoUjW8opKlAltIO7nwuzeq7ZDVay6+L2UGlKkj/HHp
         eZRlsNUrg5b75qd+ryYAdS52RfWebuifzJ9NpGO5Ko6NKGi1DNtu2VQ79Z9NY4iTI5
         FVJrd+dTULh5fr5KO78U0rH05KY4hYY4bioiWgSI=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20210609113609epcas5p21235af4b27c4c7e7b253521dc1b2958b~G5uDrE7_v2107321073epcas5p24;
        Wed,  9 Jun 2021 11:36:09 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A4.BA.09697.9A7A0C06; Wed,  9 Jun 2021 20:36:09 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20210609105347epcas5p42ab916655fca311157a38d54f79f95e7~G5JEleDmZ1718217182epcas5p4O;
        Wed,  9 Jun 2021 10:53:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210609105347epsmtrp11f28ff6a44abcbac76dab9ce1534baa2~G5JEkus3_1421214212epsmtrp1V;
        Wed,  9 Jun 2021 10:53:47 +0000 (GMT)
X-AuditID: b6c32a4a-64fff700000025e1-44-60c0a7a9df8d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        55.98.08163.BBD90C06; Wed,  9 Jun 2021 19:53:47 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210609105345epsmtip139d160f4a440ad7b08683a6b96ab98c1~G5JC8NJ832853528535epsmtip1B;
        Wed,  9 Jun 2021 10:53:45 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     lsf-pc@lists.linux-foundation.org, linux-nvme@lists.infradead.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, javier@javigon.com,
        anuj20.g@samsung.com, joshiiitr@gmail.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [LSF/MM/BPF Topic] Towards more useful nvme-passthrough
Date:   Wed,  9 Jun 2021 16:20:50 +0530
Message-Id: <20210609105050.127009-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsWy7bCmpu7K5QcSDE7e5rNomvCX2WL13X42
        i5WrjzJZvGs9x2LRefoCk8XR/2/ZLM6/PcxkMenQNUaLvbe0LeYve8puse/1XmYHbo+ds+6y
        ezQvuMPicflsqcemVZ1sHpuX1HtMvrGc0WP3zQY2j74tqxg9Pm+SC+CM4rJJSc3JLEst0rdL
        4MpYtvIWe8EVqYr/6/YyNjBuE+li5OSQEDCRaN91lrWLkYtDSGA3o8TvpkMsEM4nRomeHW+Z
        IJzPjBILDmxnhGl5+fg5VGIXo8Sdk0tZ4Kom7j/O3sXIwcEmoClxYXIpSIOIQJ3E9NOn2EBq
        mAVmMUrsPbaTDSQhLOAg8fvKf7CpLAKqEvc+7mQCsXkFLCX2dT9khdgmLzHz0nd2iLigxMmZ
        T1hAbGagePPW2cwgQyUEWjkkvry/ww7R4CJxcOJuJghbWOLV8S1QcSmJl/1tUHaxxK87R6Ga
        OxglrjfMZIFI2Etc3POXCeQDZqAP1u/ShwjLSkw9tY4JYjGfRO/vJ1DzeSV2zIOxFSXuTXoK
        dbS4xMMZS6BsD4nnM7rAbCGBWImlPzawTmCUn4Xkn1lI/pmFsHkBI/MqRsnUguLc9NRi0wKj
        vNRyveLE3OLSvHS95PzcTYzgNKXltYPx4YMPeocYmTgYDzFKcDArifCWGe5LEOJNSaysSi3K
        jy8qzUktPsQozcGiJM674uHkBCGB9MSS1OzU1ILUIpgsEwenVAPTkg2CpuI3eQI0z5/h+8Ln
        0nN4anTQ4wcNN9V48u9Nu7zJZPak99wPmjyy1OyKJmvr/2TrrW+67sl9pIjNcX7e9XfCVTJ7
        D+j+nKhpKNntHXf6s4bxDI0jW7RerY/JrFu60+C48t7qSM9KzxnfZXQ+yJ9Zd3HO+alcRTJt
        r7TvCS2YsjmFb9GKd8d/bPDW8+xerHRtJxvXksL/L+W6vG9zeXlbzYx+bXHkzr2vgX8733p4
        tIr+vLQvVzs050jzmbf1vjHnqj+3ey59Fsdy9X3honmPrqpvP3zInPmz59XK587lyis+b35e
        /9i+esl6H3vxxE4hwertWg+trs5SOxZ3+b5qdKra4hpJY57d33UUlFiKMxINtZiLihMByGuZ
        CcIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWy7bCSnO7uuQcSDCY2q1k0TfjLbLH6bj+b
        xcrVR5ks3rWeY7HoPH2ByeLo/7dsFuffHmaymHToGqPF3lvaFvOXPWW32Pd6L7MDt8fOWXfZ
        PZoX3GHxuHy21GPTqk42j81L6j0m31jO6LH7ZgObR9+WVYwenzfJBXBGcdmkpOZklqUW6dsl
        cGUsW3mLveCKVMX/dXsZGxi3iXQxcnJICJhIvHz8nKmLkYtDSGAHo8SVnqUsEAlxieZrP9gh
        bGGJlf+es0MUfWSUuL9zHZDDwcEmoClxYXIpSFxEoIlRYtqu84wgDcwCixgl7tzyArGFBRwk
        fl/5DxZnEVCVuPdxJxOIzStgKbGv+yErxAJ5iZmXvrNDxAUlTs58wgIxR16ieets5gmMfLOQ
        pGYhSS1gZFrFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREc8FpaOxj3rPqgd4iRiYPx
        EKMEB7OSCG+Z4b4EId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZ
        ODilGpgmmJaKZOxRu3hi9yIW4e4l0t7mW6WEY41VNs0uYqidUMlTVdRz6FiSt/eVKVxhNTda
        HXK/zc+rncpXv6fbf51MKqO6WX/elY3cD+3ZpD0OtEZ+X71EftYf1zvnuJzXd769tiO3cnvt
        pu1n2Fxtr/d+6VdlrD2wo/NRtXrRJi2lrdvlrEoyuSbmvusUMVvktydjW6T+DlMpn77D+757
        fbx0VarPtl3M8NmTYzMOszu+vbDDM/3ftWMRn7OftEbwVhnub4jJSpIo0v7wXls5as2kjvvS
        dotDHFb2zfUX+cdtYqm5dpdrruQJF3Hryw5rRRe6CMxysL8iammfv3LOw4srm/c+lI2aZ1Ty
        /+VXCyWW4oxEQy3mouJEAKDvwqDnAgAA
X-CMS-MailID: 20210609105347epcas5p42ab916655fca311157a38d54f79f95e7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20210609105347epcas5p42ab916655fca311157a38d54f79f95e7
References: <CGME20210609105347epcas5p42ab916655fca311157a38d54f79f95e7@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Background & objectives:
------------------------

The NVMe passthrough interface

Good part: allows new device-features to be usable (at least in raw
form) without having to build block-generic cmds, in-kernel users,
emulations and file-generic user-interfaces - all this take some time to
evolve.

Bad part: passthrough interface has remain tied to synchronous ioctl,
which is a blocker for performance-centric usage scenarios. User-space
can take the pain of implementing async-over-sync on its own but it does
not make much sense in a world that already has io_uring.

Passthrough is lean in the sense it cuts through layers of abstractions
and reaches to NVMe fast. One of the objective here is to build a
scalable pass-through that can be readily used to play with new/emerging
NVMe features.  Another is to surpass/match existing raw/direct block
I/O performance with this new in-kernel path.

Recent developments:
--------------------
- NVMe now has a per-namespace char interface that remains available/usable
  even for unsupported features and for new command-sets [1].

- Jens has proposed async-ioctl like facility 'uring_cmd' in io_uring. This
  introduces new possibilities (beyond storage); async-passthrough is one of
those. Last posted version is V4 [2].

- I have posted work on async nvme passthrough over block-dev [3]. Posted work
  is in V4 (in sync with the infra of [2]).

Early performance numbers:
--------------------------
fio, randread, 4k bs, 1 job
Kiops, with varying QD:

QD      Sync-PT         io_uring        Async-PT
1         10.8            10.6            10.6
2         10.9            24.5            24
4         10.6            45              46
8         10.9            90              89
16        11.0            169             170
32        10.6            308             307
64        10.8            503             506
128       10.9            592             596

Further steps/discussion points:
--------------------------------
1.Async-passthrough over nvme char-dev
It is in a shape to receive feedback, but I am not sure if community
would like to take a look at that before settling on uring-cmd infra.

2.Once above gets in shape, bring other perf-centric features of io_uring to
this path -
A. SQPoll and register-file: already functional.
B. Passthrough polling: This can be enabled for block and looks feasible for
char-interface as well.  Keith recently posted enabling polling for user
pass-through [4]
C. Pre-mapped buffers: Early thought is to let the buffers registered by
io_uring, and add a new passthrough ioctl/uring_cmd in driver which does
everything that passthrough does except pinning/unpinning the pages.

3. Are there more things in the "io_uring->nvme->[block-layer]->nvme" path
which can be optimized.

Ideally I'd like to cover good deal of ground before Dec. But there seems
plenty of possibilities on this path.  Discussion would help in how best to
move forward, and cement the ideas.

[1] https://lore.kernel.org/linux-nvme/20210421074504.57750-1-minwoo.im.dev@gmail.com/
[2] https://lore.kernel.org/linux-nvme/20210317221027.366780-1-axboe@kernel.dk/
[3] https://lore.kernel.org/linux-nvme/20210325170540.59619-1-joshi.k@samsung.com/
[4] https://lore.kernel.org/linux-block/20210517171443.GB2709391@dhcp-10-100-145-180.wdc.com/#t

-- 
2.25.1

