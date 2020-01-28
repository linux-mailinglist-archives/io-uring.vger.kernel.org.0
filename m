Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC9D714B316
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 11:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgA1KzU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 05:55:20 -0500
Received: from yourcmc.ru ([195.209.40.11]:35862 "EHLO yourcmc.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbgA1KzU (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 28 Jan 2020 05:55:20 -0500
Received: from yourcmc.ru (localhost [127.0.0.1])
        by yourcmc.ru (Postfix) with ESMTP id B8512FE0656;
        Tue, 28 Jan 2020 13:55:18 +0300 (MSK)
Received: from localhost (unknown [31.173.80.141])
        by yourcmc.ru (Postfix) with ESMTPSA id 5C8CAFE00CA;
        Tue, 28 Jan 2020 13:55:18 +0300 (MSK)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Pavel Begunkov" <asml.silence@gmail.com>
Subject: Re: write / fsync ordering
References: <op.0e3l6cmc0ncgu9@localhost>
 <0d073d27-221e-3f23-2ee9-6e5c52c89b5b@gmail.com>
Date:   Tue, 28 Jan 2020 13:55:17 +0300
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Vitaliy Filippov" <vitalif@yourcmc.ru>
Message-ID: <op.0e3nafvf0ncgu9@localhost>
In-Reply-To: <0d073d27-221e-3f23-2ee9-6e5c52c89b5b@gmail.com>
User-Agent: Opera Mail/12.16 (Linux)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Thanks, I'll try it :)

> Yes, it can reorder them. So, there are 2 ways:
> - wait for the completion
> - order the requests within io_uring
>
> I'd recommend the ordering option by using IOSQE_IO_LINK, which
> guarantees sequential execution of linked requests. There is also
> IOSQE_IO_DRAIN, but it's rather inefficient.

-- 
With best regards,
   Vitaliy Filippov
