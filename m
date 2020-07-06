Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3848C215904
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 16:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgGFOBm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 10:01:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21237 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729222AbgGFOBm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 10:01:42 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200706140139epoutp04169ab1538ae3814a4c3afa1b6d29eb46~fLqm1UOUm3053230532epoutp04S
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 14:01:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200706140139epoutp04169ab1538ae3814a4c3afa1b6d29eb46~fLqm1UOUm3053230532epoutp04S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594044099;
        bh=r/dgxZFDzwndXBBLDY9ZULIdgyOK//Icnp95tJ9Cro8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hEzJM6ht6xotFTo83+Rdy0BaN3x1yc4HxLMnWlXbhikorSefWHBS6BGn7ebDL9As/
         eiy8sZznX1ES8is8qU5j61Wm131FLCagnQd510zBJVDBOWzljwg5/XEg4bvgJ1TvUG
         +s+NpTw0nP8mVpm7z11yJqEaQYFsKAMV4XmLx5h0=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200706140138epcas5p16f6bc1001884616e44e50f407fc840a4~fLqmNZuNJ3229432294epcas5p1v;
        Mon,  6 Jul 2020 14:01:38 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4B.6D.09467.2CE230F5; Mon,  6 Jul 2020 23:01:38 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200706140137epcas5p338bac6dd19a756290dd75134c48760d3~fLqlCBYnJ3117831178epcas5p3K;
        Mon,  6 Jul 2020 14:01:37 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200706140137epsmtrp20352bcd7b6da4097db7205248976d35c~fLqlBHgOC0630006300epsmtrp2w;
        Mon,  6 Jul 2020 14:01:37 +0000 (GMT)
X-AuditID: b6c32a49-a3fff700000024fb-66-5f032ec2a1c2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        94.0C.08303.1CE230F5; Mon,  6 Jul 2020 23:01:37 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200706140135epsmtip198d637b3809f86e0420f957158fb5dec~fLqiuOKev1018210182epsmtip1c;
        Mon,  6 Jul 2020 14:01:34 +0000 (GMT)
Date:   Mon, 6 Jul 2020 19:28:39 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     viro@zeniv.linux.org.uk, bcrl@kvack.org, hch@infradead.org,
        Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200706135839.GA23212@test-zns>
MIME-Version: 1.0
In-Reply-To: <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsWy7bCmuu4hPeZ4g9Yz+hZzVm1jtFh9t5/N
        ouvfFhaL1vZvTBanJyxisnjXeo7F4vGdz+wWU6Y1MVrsvaVtsWfvSRaLy7vmsFms2H6ExWLb
        7/nMFq9/nGSzOP/3OKsDv8fOWXfZPTav0PK4fLbUY9OnSewe3Vd/MHr0bVnF6PF5k5xH+4Fu
        Jo9NT94yBXBGcdmkpOZklqUW6dslcGU839LPUnCHt+LHvbVsDYw7uLsYOTkkBEwk3t6cz9rF
        yMUhJLCbUWL1rlZGCOcTo8TbPVvZIJzPjBLPWtazwrT0bT7ABJHYxSjxd+cCKOcZo8TxI3uY
        QapYBFQkXiz/B9TOwcEmoClxYXIpSFhEQEGi5/dKsKnMAt3MEnc6G8HqhQUcJT7vPMkIYvMK
        6EqcfLieDcIWlDg58wkLyBxOAVuJYwcjQcKiAsoSB7YdB9srIXCFQ2Ju/wI2iOtcJKZu72KH
        sIUlXh3fAmVLSXx+txeqplji152jzBDNHYwS1xtmskAk7CUu7vnLBGIzC2RIXDg2Ecrmk+j9
        /YQJ5AgJAV6JjjYhiHJFiXuTnkJDRVzi4YwlULaHxLHmC9BAaWGSaJo2hXECo9wsJP/MQrIC
        wraS6PzQxDoLaAWzgLTE8n8cEKamxPpd+gsYWVcxSqYWFOempxabFhjmpZbrFSfmFpfmpesl
        5+duYgQnOS3PHYx3H3zQO8TIxMF4iFGCg1lJhLdXmzFeiDclsbIqtSg/vqg0J7X4EKM0B4uS
        OK/SjzNxQgLpiSWp2ampBalFMFkmDk6pBqYdmnZtQUJf5QsnPeLr25VzRfpkbefHHXILVSd+
        2ptrEPra+5VVy1nzK9M92y8vnshw55LVNK4l9vV7Q0Kfrvvm4MNx942QziXfau4p9XqX/I9e
        mSZ7aP986cDUNRaTE1/xdmp+a4oInMSo2qpi1vroxuM0J92FfA73ddcc6vROuzpdaIGM6OJt
        V8/3tYnfMVW65P7SuqO49aji52pTtsnKEq4Htjy7tZ7llvj5zBuBzz056jTajh5ukP4+4VMW
        69F0r8NFMw0tNnh1/X/GoLBT4f6H3yz6VtnWc+b/fTx949S8bW4z2Pb7P3t3qfLM1a8GaUGP
        SiaF6TS/6+5ZUX5uznNmvyM/P+guP3z+sPc/JZbijERDLeai4kQAS9nm4+EDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSnO5BPeZ4g5fHpC3mrNrGaLH6bj+b
        Rde/LSwWre3fmCxOT1jEZPGu9RyLxeM7n9ktpkxrYrTYe0vbYs/ekywWl3fNYbNYsf0Ii8W2
        3/OZLV7/OMlmcf7vcVYHfo+ds+6ye2xeoeVx+Wypx6ZPk9g9uq/+YPTo27KK0ePzJjmP9gPd
        TB6bnrxlCuCM4rJJSc3JLEst0rdL4Mq4vvU9Y0Efd8XOQxMYGxhbOLsYOTkkBEwk+jYfYAKx
        hQR2MEp8macAEReXaL72gx3CFpZY+e85kM0FVPOEUWLF8zmsIAkWARWJF8v/sXUxcnCwCWhK
        XJhcChIWEVCQ6Pm9kg2knlmgn1ni8IppzCAJYQFHic87TzKC2LwCuhInH65ngxjawiTx9to8
        doiEoMTJmU9YQGxmATOJeZsfMoMsYBaQllj+jwPE5BSwlTh2MBKkQlRAWeLAtuNMExgFZyFp
        noWkeRZC8wJG5lWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMExp6W1g3HPqg96hxiZ
        OBgPMUpwMCuJ8PZqM8YL8aYkVlalFuXHF5XmpBYfYpTmYFES5/06a2GckEB6YklqdmpqQWoR
        TJaJg1Oqgan4CZ9rdO6p/wqCHwLF1y00S96z9ayH54+G368kta2lttdM3LvM7KvQVO59/95m
        xa170en/30L3XeXvhOptB4SCVL8lW6yUbTU+2ivIn9wnumDnV4s4HTXxc2GSKx+kFSWz/Hy4
        5vT3D0VxVpKG6U+kVm3iPynGsi5/z0KO+zVroj0Vd5X7M7ILse3/MUn+nUOd4FMTraerf3Rm
        RsvmO3yy+7tsbm3UmSvlc3u3sxs9sNqwWb32ilBBxD0lb/n74R/mJhupf68XOZt9qEPlXPNT
        z0DuR7NCdhuebNdlTOD4Hln3822keamZdPPi59p9GQc/zrggUVvzs0U+dfdfllju2M+XvSI+
        99zlvm5spsRSnJFoqMVcVJwIADMMuSAoAwAA
X-CMS-MailID: 20200706140137epcas5p338bac6dd19a756290dd75134c48760d3
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----RtrVgMPcOOSLrhJloRVgptxhQONXYtyOWZJ9JvnugceJtZ1T=_db49e_"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
        <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
        <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
        <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------RtrVgMPcOOSLrhJloRVgptxhQONXYtyOWZJ9JvnugceJtZ1T=_db49e_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Sun, Jul 05, 2020 at 03:00:47PM -0600, Jens Axboe wrote:
>On 7/5/20 12:47 PM, Kanchan Joshi wrote:
>> From: Selvakumar S <selvakuma.s1@samsung.com>
>>
>> For zone-append, block-layer will return zone-relative offset via ret2
>> of ki_complete interface. Make changes to collect it, and send to
>> user-space using cqe->flags.
>>
>> Signed-off-by: Selvakumar S <selvakuma.s1@samsung.com>
>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
>> ---
>>  fs/io_uring.c | 21 +++++++++++++++++++--
>>  1 file changed, 19 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 155f3d8..cbde4df 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -402,6 +402,8 @@ struct io_rw {
>>  	struct kiocb			kiocb;
>>  	u64				addr;
>>  	u64				len;
>> +	/* zone-relative offset for append, in sectors */
>> +	u32			append_offset;
>>  };
>
>I don't like this very much at all. As it stands, the first cacheline
>of io_kiocb is set aside for request-private data. io_rw is already
>exactly 64 bytes, which means that you're now growing io_rw beyond
>a cacheline and increasing the size of io_kiocb as a whole.
>
>Maybe you can reuse io_rw->len for this, as that is only used on the
>submission side of things.

Yes, this will be good. Thanks.

------RtrVgMPcOOSLrhJloRVgptxhQONXYtyOWZJ9JvnugceJtZ1T=_db49e_
Content-Type: text/plain; charset="utf-8"


------RtrVgMPcOOSLrhJloRVgptxhQONXYtyOWZJ9JvnugceJtZ1T=_db49e_--
