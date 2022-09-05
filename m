Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC435ACA48
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 08:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiIEGDY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 02:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236339AbiIEGC6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 02:02:58 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46714248CD
        for <io-uring@vger.kernel.org>; Sun,  4 Sep 2022 23:02:06 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220905060203epoutp03a55e2ea3af9df45d91dd4bb605a1d688~R4YqrT6nq0499804998epoutp03M
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 06:02:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220905060203epoutp03a55e2ea3af9df45d91dd4bb605a1d688~R4YqrT6nq0499804998epoutp03M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662357723;
        bh=Uf3dhMGModSRR0bvHGNauCIcf1H2H99Qaa3T3nL9ivc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LIq2nsbB6CsW2m/143BQiiglDeEfwzoIUDRtLAYBo6kmZnVX2lzxXxiEkSnwqPjR5
         c5//Xy28Qqq8FVIftzzug5RduFCwU88xskC8Da3gCdDXtqAM95sT3dIkM6IaV40/sa
         ZAf+PQI0YsyzXui1cfuJ9zLew44zTw/32LVQPcX8=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220905060202epcas5p2649a3ac7e256bb83dc21071f4f0540c0~R4YqIxah23121031210epcas5p2k;
        Mon,  5 Sep 2022 06:02:02 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MLdFf3Rlqz4x9QH; Mon,  5 Sep
        2022 06:01:58 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        52.3D.54060.2D095136; Mon,  5 Sep 2022 15:01:54 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220905060154epcas5p392129e8fc4b020f61add67a01150997d~R4Yii-FcJ2814528145epcas5p3l;
        Mon,  5 Sep 2022 06:01:54 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220905060154epsmtrp26c0f1471daaace44a1715fc64013e13c~R4YiiDix81777817778epsmtrp2B;
        Mon,  5 Sep 2022 06:01:54 +0000 (GMT)
X-AuditID: b6c32a4b-e33fb7000000d32c-e9-631590d222d6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FA.4A.14392.2D095136; Mon,  5 Sep 2022 15:01:54 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220905060153epsmtip1e31feaf0b8127d20b5ce62469215d1f6~R4YhQr75U1936619366epsmtip1d;
        Mon,  5 Sep 2022 06:01:52 +0000 (GMT)
Date:   Mon, 5 Sep 2022 11:22:09 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     hch@lst.de, kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com
Subject: Re: [PATCH for-next v3 0/4] fixed-buffer for uring-cmd/passthrough
Message-ID: <20220905055209.GA26487@test-zns>
MIME-Version: 1.0
In-Reply-To: <7c0fced8-11b0-fcd9-ac47-662af979b207@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGJsWRmVeSWpSXmKPExsWy7bCmlu6lCaLJBguOGVrMWbWN0WL13X42
        i5sHdjJZrFx9lMniXes5FotJh64xWuy9pW0xf9lTdgcOj52z7rJ7XD5b6rFpVSebx+Yl9R67
        bzawefRtWcXo8XmTXAB7VLZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJu
        qq2Si0+ArltmDtBJSgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCkwK94sTc4tK8
        dL281BIrQwMDI1OgwoTsjEknXrAXzFeq2LBfvYHxkHQXIweHhICJxJo+/y5GLg4hgd2MEmdn
        fGCFcD4xSuz4+oK9i5ETyPnGKLFpeQKIDdLQ+ruNDSK+l1HizBJ5iIZnjBJ7pn9jAkmwCKhI
        XNqzjglkA5uApsSFyaUgYREBBYme3yvBepkFVjFKTPklDWILC3hLNPU9YAYp5xXQlWjukAMJ
        8woISpyc+YQFxOYUsJW4sm8KWKuogLLEgW3HmUDWSghM5JC48PM4E8RtLhJ7535kg7CFJV4d
        38IOYUtJfH63FyqeLHFp5jmo+hKJx3sOQtn2Eq2n+pkhbsuQOHP3JNSdfBK9v58wQQKLV6Kj
        TQiiXFHi3qSnrBC2uMTDGUugbA+JI/2zWCBB0soisXpeE8sERrlZSP6ZhWQFhG0l0fmhiXUW
        0ApmAWmJ5f84IExNifW79Bcwsq5ilEwtKM5NTy02LTDOSy2Hx29yfu4mRnAC1fLewfjowQe9
        Q4xMHIyHGCU4mJVEeFN2iCQL8aYkVlalFuXHF5XmpBYfYjQFxs5EZinR5HxgCs8riTc0sTQw
        MTMzM7E0NjNUEuedos2YLCSQnliSmp2aWpBaBNPHxMEp1cC0ZPdfHrlZBlvXWuzMSskv0Imd
        vkbqbbnrnQPRRbEl2vKci60VM6oTl7PfN/8kHBV93P19dP3L5K8XHJsLd7m3TWiPSwy5PuNr
        832hi0cWndN5tubsfc/ex6mrKxonvZrzYi5n+M89fye4FSQ9fDfl5yvVTJXTE3MvcRx/eldP
        a3dKyXyGG0un7Is+UMj18+jb9x+OKCTcif7EveujY7aW+62VGd/sbnl/29T/raQwlc3pW8gC
        lyDxkBrR6JO59lqdPyNk8xRFc/vnfEs/VabjJnnjgVmjX4TT96yLz9hr2z+pOzx7p2ucmvop
        bath1fSDBly/9Fj293UemDGz/0v+216hO+/WSBrVS95h3XZZiaU4I9FQi7moOBEAEcOs2SkE
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSnO6lCaLJBr+XiljMWbWN0WL13X42
        i5sHdjJZrFx9lMniXes5FotJh64xWuy9pW0xf9lTdgcOj52z7rJ7XD5b6rFpVSebx+Yl9R67
        bzawefRtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG4uMuBeflK5pW/WJpYOyT7GLk5JAQMJFo
        /d3G1sXIxSEksJtRYsODeUwQCXGJ5ms/2CFsYYmV/56zQxQ9YZS4v/QvM0iCRUBF4tKedUAN
        HBxsApoSFyaXgoRFBBQken6vZAOxmQVWMUpM+SUNYgsLeEs09T1gBinnFdCVaO6QAwkLCbSy
        SBw9lQli8woISpyc+YQFotVMYt7mh2DlzALSEsv/cYCEOQVsJa7smwI2XVRAWeLAtuNMExgF
        ZyHpnoWkexZC9wJG5lWMkqkFxbnpucWGBYZ5qeV6xYm5xaV56XrJ+bmbGMFRoaW5g3H7qg96
        hxiZOBgPMUpwMCuJ8KbsEEkW4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6Yklqdmpq
        QWoRTJaJg1Oqgelc/8VL6+TPL1oRF8W94sKXipYpojP1+H4wV6aEKTTssp68V/Nq0I/KoM4z
        SdpWFyIUo0OvWfI5nFvzsn/u34q7y30WuXw78HzHV74vhxskv1ywkhW7edl91iFp+TnvrT7Z
        Fb3gf6fuknD21a+cU493FPzMnumVprp6xsN3J97XMZ1ObhLt6NwyqUfy+9vVQqIn3x7bxbf/
        2KGsXTKzrToeagSVvlj/5a7P2gNfz0zKm/VSXjvbPeJbmOHngp0brdNLt17ZbBboNOOjW/3S
        OC/FxCOnQ1gOcU4/uvS6dOE16YRJmeqZxYH2Fs8rUjPs11pdTH635ZKt3JvqSv/lB6OlLhhI
        6HnJrf1wvX/bkSI+JZbijERDLeai4kQAidHSrPkCAAA=
X-CMS-MailID: 20220905060154epcas5p392129e8fc4b020f61add67a01150997d
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----W1bEPTvsorsTcy9-0QGogbD0KLvGmowfrJUeCoG.R5S2F01G=_dd767_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220902152701epcas5p1d4aca8eebc90fb96ac7ed5a8270816cf
References: <CGME20220902152701epcas5p1d4aca8eebc90fb96ac7ed5a8270816cf@epcas5p1.samsung.com>
        <20220902151657.10766-1-joshi.k@samsung.com>
        <f1e8a7fa-a1f8-c60a-c365-b2164421f98d@kernel.dk>
        <2b4a935c-a6b1-6e42-ceca-35a8f09d8f46@kernel.dk>
        <20220902184608.GA6902@test-zns>
        <48856ca4-5158-154e-a1f5-124aadc9780f@kernel.dk>
        <c62c977d-9e81-c84c-e17c-e057295c071e@kernel.dk>
        <75c6c9ea-a5b4-1ef5-7ff1-10735fac743e@kernel.dk>
        <20220904170124.GC10536@test-zns>
        <7c0fced8-11b0-fcd9-ac47-662af979b207@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------W1bEPTvsorsTcy9-0QGogbD0KLvGmowfrJUeCoG.R5S2F01G=_dd767_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Sun, Sep 04, 2022 at 02:17:33PM -0600, Jens Axboe wrote:
>On 9/4/22 11:01 AM, Kanchan Joshi wrote:
>> On Sat, Sep 03, 2022 at 11:00:43AM -0600, Jens Axboe wrote:
>>> On 9/2/22 3:25 PM, Jens Axboe wrote:
>>>> On 9/2/22 1:32 PM, Jens Axboe wrote:
>>>>> On 9/2/22 12:46 PM, Kanchan Joshi wrote:
>>>>>> On Fri, Sep 02, 2022 at 10:32:16AM -0600, Jens Axboe wrote:
>>>>>>> On 9/2/22 10:06 AM, Jens Axboe wrote:
>>>>>>>> On 9/2/22 9:16 AM, Kanchan Joshi wrote:
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> Currently uring-cmd lacks the ability to leverage the pre-registered
>>>>>>>>> buffers. This series adds the support in uring-cmd, and plumbs
>>>>>>>>> nvme passthrough to work with it.
>>>>>>>>>
>>>>>>>>> Using registered-buffers showed peak-perf hike from 1.85M to 2.17M IOPS
>>>>>>>>> in my setup.
>>>>>>>>>
>>>>>>>>> Without fixedbufs
>>>>>>>>> *****************
>>>>>>>>> # taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1
>>>>>>>>> submitter=0, tid=5256, file=/dev/ng0n1, node=-1
>>>>>>>>> polled=0, fixedbufs=0/0, register_files=1, buffered=1, QD=128
>>>>>>>>> Engine=io_uring, sq_ring=128, cq_ring=128
>>>>>>>>> IOPS=1.85M, BW=904MiB/s, IOS/call=32/31
>>>>>>>>> IOPS=1.85M, BW=903MiB/s, IOS/call=32/32
>>>>>>>>> IOPS=1.85M, BW=902MiB/s, IOS/call=32/32
>>>>>>>>> ^CExiting on signal
>>>>>>>>> Maximum IOPS=1.85M
>>>>>>>>
>>>>>>>> With the poll support queued up, I ran this one as well. tldr is:
>>>>>>>>
>>>>>>>> bdev (non pt)??? 122M IOPS
>>>>>>>> irq driven??? 51-52M IOPS
>>>>>>>> polled??????? 71M IOPS
>>>>>>>> polled+fixed??? 78M IOPS
>>>
>>> Followup on this, since t/io_uring didn't correctly detect NUMA nodes
>>> for passthrough.
>>>
>>> With the current tree and the patchset I just sent for iopoll and the
>>> caching fix that's in the block tree, here's the final score:
>>>
>>> polled+fixed passthrough??? 105M IOPS
>>>
>>> which is getting pretty close to the bdev polled fixed path as well.
>>> I think that is starting to look pretty good!
>> Great! In my setup (single disk/numa-node), current kernel shows-
>>
>> Block MIOPS
>> ***********
>> command:t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -P1 -n1 /dev/nvme0n1
>> plain: 1.52
>> plain+fb: 1.77
>> plain+poll: 2.23
>> plain+fb+poll: 2.61
>>
>> Passthru MIOPS
>> **************
>> command:t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -P1 -u1 -n1 /dev/ng0n1
>> plain: 1.78
>> plain+fb: 2.08
>> plain+poll: 2.21
>> plain+fb+poll: 2.69
>
>Interesting, here's what I have:
>
>Block MIOPS
>============
>plain: 2.90
>plain+fb: 3.0
>plain+poll: 4.04
>plain+fb+poll: 5.09	
>
>Passthru MIPS
>=============
>plain: 2.37
>plain+fb: 2.84
>plain+poll: 3.65
>plain+fb+poll: 4.93
>
>This is a gen2 optane
same. Do you see same 'FW rev' as below?

# nvme list
Node                  SN                   Model                                    Namespace Usage                      Format           FW Rev
--------------------- -------------------- ---------------------------------------- --------- -------------------------- ---------------- --------
/dev/nvme0n1          PHAL11730018400AGN   INTEL SSDPF21Q400GB                      1         400.09  GB / 400.09  GB    512   B +  0 B   L0310200


>, it maxes out at right around 5.1M IOPS. Note that
>I have disabled iostats and merges generally in my runs:
>
>echo 0 > /sys/block/nvme0n1/queue/iostats
>echo 2 > /sys/block/nvme0n1/queue/nomerges
>
>which will impact block more than passthru obviously, particularly
>the nomerges. iostats should have a similar impact on both of them (but
>I haven't tested either of those without those disabled).

bit improvment after disabling, but for all entries.

block
=====
plain: 1.6
plain+FB: 1.91
plain+poll: 2.36
plain+FB+poll: 2.85

passthru
========
plain: 1.9
plain+FB: 2.2
plain+poll: 2.4
plain+FB+poll: 2.9

Maybe there is something about my kernel-config that prevents from
reaching to expected peak (i.e. 5.1M). Will check more.





------W1bEPTvsorsTcy9-0QGogbD0KLvGmowfrJUeCoG.R5S2F01G=_dd767_
Content-Type: text/plain; charset="utf-8"


------W1bEPTvsorsTcy9-0QGogbD0KLvGmowfrJUeCoG.R5S2F01G=_dd767_--
