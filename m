Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E271538BC6
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 09:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242269AbiEaHFZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 03:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244432AbiEaHFX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 03:05:23 -0400
Received: from pv50p00im-ztdg10011901.me.com (pv50p00im-ztdg10011901.me.com [17.58.6.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEBA98083
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 00:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1653980721;
        bh=sOS0rwMjIDXK5U9uZFx+VlOCu0Oasf90AKFaKnS/d2k=;
        h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
        b=ZG11azafcdu9vKXHnaleGc0APSvCUaanunSIS+OdbRlEGsEMVF//+Z5/TcC4LeDfv
         O1ypEVTSDbX8FodnK8LYVFiT5hEUykbzXzoQRCtUKhhq19inW63LPLHuAo33FKqD6N
         C3ZHjz83R9x5L7zZm/Zsn0XDXA+DxOqFwsqIY+mT58+w3kiuSghqX2h7ceS2DM0n6Y
         JxRtDbtmheWHJ7W6g2jIo/pCsfCnegqE+9w8KGV37LFXXF1V3cJr3myPr2LVTGuVNp
         zeilDNRvlr6q7OMVoEJwFCgMWnRGliZLgv5YWv1R/t3bmcz3yDDcwh+hAK387GBfG3
         LNUIe6qIATo3g==
Received: from [10.97.63.88] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10011901.me.com (Postfix) with ESMTPSA id C5A543A0598;
        Tue, 31 May 2022 07:05:18 +0000 (UTC)
Message-ID: <1071c09c-8670-b883-5b64-2cd1fb69d943@icloud.com>
Date:   Tue, 31 May 2022 15:05:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v4 00/11] fixed worker
Content-Language: en-US
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20220515131230.155267-1-haoxu.linux@icloud.com>
In-Reply-To: <20220515131230.155267-1-haoxu.linux@icloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-05-31_02:2022-05-30,2022-05-31 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205310036
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/15/22 21:12, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> This is the second version of fixed worker implementation.
> Wrote a nop test program to test it, 3 fixed-workers VS 3 normal workers.
> normal workers:
> ./run_nop_wqe.sh nop_wqe_normal 200000 100 3 1-3
>          time spent: 10464397 usecs      IOPS: 1911242
>          time spent: 9610976 usecs       IOPS: 2080954
>          time spent: 9807361 usecs       IOPS: 2039284
> 
> fixed workers:
> ./run_nop_wqe.sh nop_wqe_fixed 200000 100 3 1-3
>          time spent: 17314274 usecs      IOPS: 1155116
>          time spent: 17016942 usecs      IOPS: 1175299
>          time spent: 17908684 usecs      IOPS: 1116776
> 
> About 2x improvement. From perf result, almost no acct->lock contension.
> Test program: https://github.com/HowHsu/liburing/tree/fixed_worker
> liburing/test/nop_wqe.c
> 
> v3->v4:
>   - make work in fixed worker's private worfixed worker
>   - tweak the io_wqe_acct struct to make it clearer
> 

Hi Jens and Pavel,
Any comments on this series? There are two coding style issue and I'm
going to send v5, before this I'd like to get some comment if there is
any.

Thanks,
Hao
