Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0227853E2F7
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 10:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiFFID7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 04:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiFFIDs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 04:03:48 -0400
Received: from pv50p00im-ztbu10021601.me.com (pv50p00im-ztbu10021601.me.com [17.58.6.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C6637029
        for <io-uring@vger.kernel.org>; Mon,  6 Jun 2022 01:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1654502623;
        bh=Ura5+QuQvnqIc2qc5BHAESD8eUJY/TER15Piyt3Pc0Q=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=VsGP6w+2scRMUNv/RfLR9cBBWjf+yfJ+5pvP75VqssZQyXE/6zsl8Bb72FUTFeZRn
         FyYanZOwqcV7wnYOjuvvXfyx/0dqt/Iguk2YzX8XHemSJzANR/rKFjg43yqGaDPame
         T2oM4m7+JkvqlXeoCX66NDBNc2vCngQ/qcN8R5zpJK7HIPtxpVdzSJ1Y9cNCbxyriL
         seIVn/vZC08jGIcNoDUMBgiUtrk2x/eqUFmOtjpw9j3LcJGzGXL6lVPCsLDaIf9kjU
         ue1WUigkc5rMS8i13BDoS4b3SoQBHEyp1iplU9Gtx59AyDaMV+giNu0WC8cx5YHDRp
         Etai22LIrIdrg==
Received: from [10.97.63.88] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztbu10021601.me.com (Postfix) with ESMTPSA id AD19580458;
        Mon,  6 Jun 2022 08:03:39 +0000 (UTC)
Message-ID: <68d58735-3951-bc13-b8b8-47bc1df4d72c@icloud.com>
Date:   Mon, 6 Jun 2022 16:03:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v1 0/5] Ensure io_uring data structure consistentcy in
 liburing
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220606061209.335709-1-ammarfaizi2@gnuweeb.org>
From:   Hao Xu <haoxu.linux@icloud.com>
In-Reply-To: <20220606061209.335709-1-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-06_02:2022-06-02,2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=659 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2206060037
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/6/22 14:12, Ammar Faizi wrote:
> 
> Hi,
> 
> This is an RFC for liburing-2.3.
> 
> ## Introduction:
> This series adds compile time assertions for liburing. They are taken
> from the io_uring source in the kernel tree. The point of this series
> is to make sure the shared struct is consistent between the kernel
> space and user space.
> 
> 
> ## Implementation detail:
> We use `static_assert()` macro from <assert.h> that can yield compile
> error if the expression given to it evaluates to false. This way we
> can create a `BUILD_BUG_ON()` macro that we usually use inside the
> kernel. The assertions are placed inside a header file named
> build_assert.h, this header is included via compile flag `-include`
> when compiling the core liburing sources.
> 
> 
> ## How to maintain this?
> This is pretty much easy to maintain, we just need to sync the
> `BUILD_BUG_ON()` macro calls that check the shared struct from
> io_uring. See patch #5 for detail.
> 
> 

Looks good to me,
Acked-by: Hao Xu <howeyxu@tencent.com>

