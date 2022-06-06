Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82FC553E3CF
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 10:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiFFHQW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 03:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiFFHQV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 03:16:21 -0400
Received: from pv50p00im-ztdg10012101.me.com (pv50p00im-ztdg10012101.me.com [17.58.6.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC1422B22
        for <io-uring@vger.kernel.org>; Mon,  6 Jun 2022 00:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1654499205;
        bh=xVq79GIbXcLp1DGC09r82Kf3T4eWxgEtRNRVkXRzIeg=;
        h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
        b=WfUl5f8UV7EAgYzhvv+CQqljvVJa69F4HMnVIXVjVQ+uQrWro5GG8bH0amLh3QmZD
         avLnvaCOHhEJ1kMNtyZ5xXCSTFdxyzeKhly1mpJ90XC5DvXax84hEjzht7yvVsR85q
         gVhyVQBn4Pgwe1IFHc49dZXpMIjhoTaBn3Fn2FZPuhoI3vjn4ve1BLCYKCSSb7DMDj
         0pmpO7h1XRV9HG+j3ABmN8dmXZxIMPbkOZ6bhI/e9FX5tyubuV1amV7eJFK0lNC3ma
         nxC4zPmX9z/1hQzWkkugW8Le88KsdHQU+XHS3RJ2XtI/Y2OSgei3fUhyn7t8tsyufy
         w54nOkVyny5EA==
Received: from [10.97.63.88] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10012101.me.com (Postfix) with ESMTPSA id 0CD5B74020F;
        Mon,  6 Jun 2022 07:06:41 +0000 (UTC)
Message-ID: <da7624f0-ed08-eb94-621e-ed3e0751dfed@icloud.com>
Date:   Mon, 6 Jun 2022 15:06:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 0/3] cancel_hash per entry lock
Content-Language: en-US
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20220606065716.270879-1-haoxu.linux@icloud.com>
In-Reply-To: <20220606065716.270879-1-haoxu.linux@icloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-06_02:2022-06-02,2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=605 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2206060032
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/6/22 14:57, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Make per entry lock for cancel_hash array, this reduces usage of
> completion_lock and contension between cancel_hash entries.
> 
> v1->v2:
>   - Add per entry lock for poll/apoll task work code which was missed
>     in v1
>   - add an member in io_kiocb to track req's indice in cancel_hash

Tried to test it with many poll_add IOSQQE_ASYNC requests but turned out
that there is little conpletion_lock contention, so no visible change in
data. But I still think this may be good for cancel_hash access in some
real cases where completion lock matters.

Regards,
Hao
