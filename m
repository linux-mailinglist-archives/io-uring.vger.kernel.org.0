Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9058052A4A3
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 16:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348819AbiEQOUR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 10:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348784AbiEQOUL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 10:20:11 -0400
Received: from pv50p00im-zteg10011501.me.com (pv50p00im-zteg10011501.me.com [17.58.6.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FB14D243
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 07:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1652797210;
        bh=geg8inb2iduMEB0nW1eJYSyHlX6OcII9pUc2E1qTSMA=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=IVdRpeNOkemNz+DDDPBnsVVFFRFqxVimScvUJZiZlslaJMXbt87TuPx4RX5XSuVaG
         qATfm4uiWKt9BIhQExsRXUHRZ2Uu//J4tJ3E+OXsXnbf2foYcCdukc5+pi82bKrKSr
         HCLH1JPXWjxxRYjemnTbyCeGYquJoKkIEBjpEVUMsIaHqcaMmT56rN0zuasZxpBsV2
         k7GHNKDX18SPpT+d5bzIApQiCKh88K8YxkCgJjMVAeGTmP1+iMdchgPvGjCG0jfoKr
         1CWFWq7BU7+CCS8dFpHh3w018telhnnOeQxT+aG0vIBaoufurObOTGFvNhuc5tv/U2
         238rhq46PDe5Q==
Received: from [10.97.63.88] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-zteg10011501.me.com (Postfix) with ESMTPSA id 67E302E035A;
        Tue, 17 May 2022 14:20:08 +0000 (UTC)
Message-ID: <06535662-787c-d232-aaf5-3f5829ca48a7@icloud.com>
Date:   Tue, 17 May 2022 22:20:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCHSET v6 0/3] Add support for ring mapped provided buffers
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220516162118.155763-1-axboe@kernel.dk>
From:   Hao Xu <haoxu.linux@icloud.com>
In-Reply-To: <20220516162118.155763-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205170088
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/22 00:21, Jens Axboe wrote:
> Hi,
> 
> This series builds to adding support for a different way of doing
> provided buffers, which is a lot more efficient than the existing scheme
> for high rate of consumption/provision of buffers. The interesting bits
> here are patch 3, which also has some performance numbers an an
> explanation of it.
> 
> Patch 1 adds NOP support for provided buffers, just so that we can
> benchmark the last change.
> 
> Patch 2 just abstracts out the pinning code.
> 
> Patch 3 adds the actual feature.
> 
> This passes the full liburing suite, and various test cases I adopted
> to use ring provided buffers.
> 
> v6:
> - Change layout so that 'head' overlaps with reserved field in first
>    buffer, avoiding the weird split of first page having N-1 buffers and
>    the rest N (Dylan)
> - Rebase on current kernel bits
> - Fix missing ring unlock on out-of-bufs
> - Fix issue in io_recv()
> 
> Can also be found in my git repo, for-5.19/io_uring-pbuf branch:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-pbuf
> 
> and there's an associated liburing branch too:
> 
> https://git.kernel.dk/cgit/liburing/log/?h=huge

should be the buf-ring branch I guess

> 
>   fs/io_uring.c                 | 323 +++++++++++++++++++++++++++++-----
>   include/uapi/linux/io_uring.h |  36 ++++
>   2 files changed, 319 insertions(+), 40 deletions(-)
> 

