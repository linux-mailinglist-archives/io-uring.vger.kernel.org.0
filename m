Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD496CB5C8
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 07:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjC1FLc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Mar 2023 01:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjC1FLa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Mar 2023 01:11:30 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBC32113
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 22:11:27 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230328051123epoutp03b2299773806529ef3371f713c1d6bd47~QfSrQVF-62856528565epoutp03F
        for <io-uring@vger.kernel.org>; Tue, 28 Mar 2023 05:11:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230328051123epoutp03b2299773806529ef3371f713c1d6bd47~QfSrQVF-62856528565epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1679980283;
        bh=9Avr+yTfa9LLK9saCK49G1DKCcPcrY/twlH1AMLYC+Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CdqapUn+yKWgSQBQ604LYFowne4Z+4wvN0Cd6hAcVtcqiiXqH+9J+Y/c1ydGMOGuT
         o24dxLoTlj9Gb1eSGLpHWD/McWJ7T954pXRhJWoDrD0rM5D+YhYev71cP0jfuJR7uM
         iCKN29JLrifFJ8Rw18M0B0L69KFeYSJBXvYi9qfc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230328051123epcas5p35abba1121e835d343c49beaaa5ded462~QfSq7Hdhn0185101851epcas5p3U;
        Tue, 28 Mar 2023 05:11:23 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4PlyT53s7vz4x9QK; Tue, 28 Mar
        2023 05:11:21 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A7.E9.55678.8F672246; Tue, 28 Mar 2023 14:11:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230328051120epcas5p23b4a173dadbd6f125c881d3809202d85~QfSnsiGbd1367713677epcas5p2m;
        Tue, 28 Mar 2023 05:11:20 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230328051120epsmtrp2790b231483430685416c7b3c303e01a2~QfSnrlTFx0876108761epsmtrp2K;
        Tue, 28 Mar 2023 05:11:20 +0000 (GMT)
X-AuditID: b6c32a4a-6a3ff7000000d97e-be-642276f89e8a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        39.F9.18071.7F672246; Tue, 28 Mar 2023 14:11:19 +0900 (KST)
Received: from green5 (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230328051117epsmtip1945862bfadb3271bf9b732bc79c0b27f~QfSluiTd_2317323173epsmtip1w;
        Tue, 28 Mar 2023 05:11:17 +0000 (GMT)
Date:   Tue, 28 Mar 2023 10:40:37 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH V4 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <20230328051037.GB8405@green5>
MIME-Version: 1.0
In-Reply-To: <20230324135808.855245-1-ming.lei@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKJsWRmVeSWpSXmKPExsWy7bCmhu6PMqUUgxX9AhZzVm1jtFh9t5/N
        4uH7J2wW71rPsVjsvaVtcXnXHDaLQ5ObmSxm9p1hsng96T+rxaa/J5ks2p9OYnTg9pjytI/d
        Y+esu+wel8+Weux8aOnxft9VNo/Pm+QC2KKybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
        dQ0tLcyVFPISc1NtlVx8AnTdMnOAjlNSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTk
        FJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGe0v3/OVLCTp6Lz7X7GBsZNXF2MnBwSAiYSZ04f
        ZOti5OIQEtjNKNF/bDEThPOJUWL58q/sEM43RonZS/6ywrR8ffSCGSKxF6jq11Yo5wmjxNM9
        jSxdjBwcLAKqEn+WFYKYbAKaEhcml4L0iggoSdy9uxpsKLPATyaJE5+mMoMkhAVcJI7dbACz
        eQW0JNZt74SyBSVOznzCAmJzClhJzDnUyQRiiwooSxzYdhzsVAmBuRwS9651MENc5yJx/dhC
        KFtY4tXxLewQtpTE53d72SDsZIlLM88xQdglEo/3HISy7SVaT/WD9TILZEo8OTGNHcLmk+j9
        /YQJ5BkJAV6JjjYhiHJFiXuTnkIDRVzi4YwlULaHxKpPj6Eh18socez/T7YJjHKzkPwzC8kK
        CNtKovNDE+ssoBXMAtISy/9xQJiaEut36S9gZF3FKJlaUJybnlpsWmCUl1oOj+Tk/NxNjOD0
        quW1g/Hhgw96hxiZOBgPMUpwMCuJ8G72VkwR4k1JrKxKLcqPLyrNSS0+xGgKjJ6JzFKiyfnA
        BJ9XEm9oYmlgYmZmZmJpbGaoJM6rbnsyWUggPbEkNTs1tSC1CKaPiYNTqoEpg9Ei/GHRnzlF
        D8/2KZrbLD9wcHXU32Xmz06I3Jr54/xc5g7LUtPNRbzfbHyTlvCeyGs+l//JWSP2e11WNjvT
        0nnrJCs/HFugtvrYwkTTBIMFP21KrZxjDcOEub7vcP2dEct/4+S6X4Z+i1fvNt8euMToZ8GH
        Bhv1yasenLlq9rut9kKifGd8kv7lT912IQ+jHrXKfV/2+p6zTfy+c9UdMvs//zTjvTjr3r5t
        JxsvTt55fK+AvFKc4PY9db9Xsz7hmiS2math38ciM9n17o9bNucf9Lp8/fii/qCSbRXSH9Z/
        /PiVV3D1sVWsqfeePY0/l77xtFqsrvTGrar/H190dmZwtHl5d8L1dQySyv1zmJVYijMSDbWY
        i4oTATiZqWc4BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsWy7bCSnO73MqUUgyVtFhZzVm1jtFh9t5/N
        4uH7J2wW71rPsVjsvaVtcXnXHDaLQ5ObmSxm9p1hsng96T+rxaa/J5ks2p9OYnTg9pjytI/d
        Y+esu+wel8+Weux8aOnxft9VNo/Pm+QC2KK4bFJSczLLUov07RK4Mp6f/s9U8IKz4vDb52wN
        jL/Zuxg5OSQETCS+PnrB3MXIxSEksJtR4lT3V6iEuETztR9QtrDEyn/P2SGKHjFKfF+6m7GL
        kYODRUBV4s+yQhCTTUBT4sLkUpByEQElibt3V4OVMwv8ZZJ4fOcNK0hCWMBF4tjNBmYQm1dA
        S2Ld9k6oxb2MEnMuPWSFSAhKnJz5hAXEZhYwk5i3+SEzyAJmAWmJ5f84QMKcAlYScw51MoHY
        ogLKEge2HWeawCg4C0n3LCTdsxC6FzAyr2KUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93E
        CI4XLc0djNtXfdA7xMjEwXiIUYKDWUmEd7O3YooQb0piZVVqUX58UWlOavEhRmkOFiVx3gtd
        J+OFBNITS1KzU1MLUotgskwcnFINTH6n2CYf8zp2sOgn+7mPVSpCkhcPadod5ZQ4/73Vv26p
        u/P2L3lsXYU5N6wb787avGt35o1VThVdpxM+xfRcbk836KrqyHurzpqwOGB7bOWHyZs+POAr
        rTwY9ptXlilcZp3ZVN1ladu5d+xl7Tm0qGufXKinWuKZmfc4nfa8qMp5deCme9CxGT58G/0v
        837acG9bEbvkGiYe/SmfpQx3bedqmP/vtjbHRaMjYi4z7c7on3p9aVfTlp9WNid6q7eH1vNZ
        iRueqX/Ql/R8X+PqZUL5u1kkPEpTD76WEfGwb5lzTV1FJPXrIY1igUeR9bq8C/wXGTJe5kle
        VhqyqKJnTZ2jg4fiz7RvoVtEXA4dUmIpzkg01GIuKk4EANNV18YGAwAA
X-CMS-MailID: 20230328051120epcas5p23b4a173dadbd6f125c881d3809202d85
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_11136e_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230324135916epcas5p37aad4c49c76c05567a484377d8909092
References: <CGME20230324135916epcas5p37aad4c49c76c05567a484377d8909092@epcas5p3.samsung.com>
        <20230324135808.855245-1-ming.lei@redhat.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_11136e_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Mar 24, 2023 at 09:57:51PM +0800, Ming Lei wrote:
>Hello Jens,
>
>Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
>be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
>64byte SQE(slave) is another normal 64byte OP. For any OP which needs
>to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
>and its ->issue() can retrieve/import buffer from master request's
>fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
>this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
>submits slave OP just like normal OP issued from userspace, that said,
>SQE order is kept, and batching handling is done too.
>
>Please see detailed design in commit log of the 2th patch, and one big
>point is how to handle buffer ownership.
>
>With this way, it is easy to support zero copy for ublk/fuse device.
>
>Basically userspace can specify any sub-buffer of the ublk block request
>buffer from the fused command just by setting 'offset/len'
>in the slave SQE for running slave OP. 

Wondering if this new OP can also be used to do larger IO (than
device limit) on nvme-passthrough?
For example, 1MB IO on NVMe than has 512k or 256K maximum transfer
size.

------KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_11136e_
Content-Type: text/plain; charset="utf-8"


------KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_11136e_--
