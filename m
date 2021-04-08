Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF5D358D80
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 21:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhDHTd7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Apr 2021 15:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbhDHTd7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Apr 2021 15:33:59 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1C9C061760
        for <io-uring@vger.kernel.org>; Thu,  8 Apr 2021 12:33:48 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id ay2so1581262plb.3
        for <io-uring@vger.kernel.org>; Thu, 08 Apr 2021 12:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=iNUV5Xh7Ax2z63pVpUG2PHFDNp3G1RyPuZYUGEdkTsA=;
        b=1HOtkoY+cLN+SEtmYgYh5SQcedbaR3dgzFUPil+xQLpUSnG+WSqqzMRiPcP8xFUSxw
         b5MRa8VZCR+Wv2wFDx4MDzTAe+lxZagyjWl1VR8ugMp8yQQjR3Y0gCyh+xuC4qB5v5e2
         wnbFWBweEOz5D7XfM6KhvtrDhZaZo/5+qs1ZqpzConja86EOKQYonCOxsr/BHXILZQDn
         oh3WimxqPUbK8xlmUo/LnHiXnhvD/sXG6XNLhwtxzoIbyO59xLEwT7l5rMcwrZqyqEXu
         SsfIhmLoDYf8u8SRCMtwJTUeiBfHbVqICHaoAOIJup2oatK+jQlOYocR6H23AgXu2jIc
         oK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iNUV5Xh7Ax2z63pVpUG2PHFDNp3G1RyPuZYUGEdkTsA=;
        b=PSKLQaZoO1xFY45sae4v1ZUVhKk0h8kVIJsbcFjCfFZVg2b6PcqpK+VlSrJsuEcTlW
         Acg5TZ8SoRwK0p8UcwUC1M/116HQ/tMJZyTIwlLM2LtLtR873QhvhTfFsa0iO9eiSsYB
         dis47ZMPy35zim+nPi0pF4L9+F4+Nr3nuQTvVRWd2pc7Hvkq45ajJiKo1iGbnDq0ElSM
         FdOSjKCYJV7Hr84mX0xjlzxrjfwNC0JlMCvn2uJLaNJoqUMJLsIPMSsLeKgLvW7WH8b4
         yvNTOqeW5A/z4H0JZBh2svuXwUZCdyTDX1iWv7gJGbz3s7bu5Ll5LU07zNhIGlsama60
         K2nQ==
X-Gm-Message-State: AOAM530m1OXlIweTfh9vFofF8489Lbn6xsdtelS5VA21iDNOvE274I0v
        aNOXS6jfDXZDsSquoheM/62p69RehKSvmA==
X-Google-Smtp-Source: ABdhPJygKmZhu5mjlsmP0ncTQ05M7x9Rn6LV/vtij82dZqfst03Nxd0SjTtGtAUirsSoWk3TgwHJfw==
X-Received: by 2002:a17:902:c408:b029:e7:3242:5690 with SMTP id k8-20020a170902c408b02900e732425690mr9419058plk.85.1617910427324;
        Thu, 08 Apr 2021 12:33:47 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 144sm230431pfy.75.2021.04.08.12.33.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 12:33:46 -0700 (PDT)
Subject: Re: [PATCH 5.12 v3] io_uring: fix rw req completion
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <01f81563aacb51972dacff4f2080087c321e424a.1617906241.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5dc06cf4-fdf8-62b3-20df-e2edaee06317@kernel.dk>
Date:   Thu, 8 Apr 2021 13:33:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <01f81563aacb51972dacff4f2080087c321e424a.1617906241.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/8/21 12:28 PM, Pavel Begunkov wrote:
> WARNING: at fs/io_uring.c:8578 io_ring_exit_work.cold+0x0/0x18
> 
> As reissuing is now passed back by REQ_F_REISSUE and kiocb_done()
> internally uses __io_complete_rw(), it may stop after setting the flag
> so leaving a dangling request.
> 
> There are tricky edge cases, e.g. reading beyound file, boundary, so
> the easiest way is to hand code reissue in kiocb_done() as
> __io_complete_rw() was doing for us before.
> 
> Fixes: 230d50d448ac ("io_uring: move reissue into regular IO path")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Link: https://lore.kernel.org/r/f602250d292f8a84cca9a01d747744d1e797be26.1617842918.git.asml.silence@gmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
> 
> 
> v2: io_rw_reissue() may fail, check return code
> v3: adjust commit message
> 
>  fs/io_uring.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f1881ac0744b..f2df0569a60a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2762,6 +2762,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
>  {
>  	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
>  	struct io_async_rw *io = req->async_data;
> +	bool check_reissue = (kiocb->ki_complete == io_complete_rw);

I removed these unnecessary parens, and updated the patch. Thanks.

-- 
Jens Axboe

