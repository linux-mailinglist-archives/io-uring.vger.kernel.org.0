Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7D6407444
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 02:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbhIKAxw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Sep 2021 20:53:52 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9414 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234978AbhIKAxw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Sep 2021 20:53:52 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H5vHN1ySFz8td8;
        Sat, 11 Sep 2021 08:48:16 +0800 (CST)
Received: from dggpemm500004.china.huawei.com (7.185.36.219) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 11 Sep 2021 08:52:39 +0800
Received: from [10.174.177.91] (10.174.177.91) by
 dggpemm500004.china.huawei.com (7.185.36.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 11 Sep 2021 08:52:38 +0800
Subject: Re: [PATCH -next v2] io-wq: Fix memory leak in create_io_worker
To:     Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
        <io-uring@vger.kernel.org>
CC:     <asml.silence@gmail.com>, <john.wanghui@huawei.com>
References: <20210910072910.43319-1-cuibixuan@huawei.com>
 <813cb232-df7e-bdc4-5e89-9bf5c5be75c1@kernel.dk>
From:   Bixuan Cui <cuibixuan@huawei.com>
Message-ID: <c8471c01-24e7-1adf-b70b-9ae4ec788aa3@huawei.com>
Date:   Sat, 11 Sep 2021 08:52:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <813cb232-df7e-bdc4-5e89-9bf5c5be75c1@kernel.dk>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500004.china.huawei.com (7.185.36.219)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2021/9/10 20:22, Jens Axboe wrote:
> A fix for this was already merged:
> 
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.15&id=66e70be722886e4f134350212baa13f217e39e42
ok.
