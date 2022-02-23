Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76804C1F55
	for <lists+io-uring@lfdr.de>; Thu, 24 Feb 2022 00:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244710AbiBWXHX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Feb 2022 18:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237315AbiBWXHX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Feb 2022 18:07:23 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5C735DCF
        for <io-uring@vger.kernel.org>; Wed, 23 Feb 2022 15:06:53 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id d3so326532wrf.1
        for <io-uring@vger.kernel.org>; Wed, 23 Feb 2022 15:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pvjhoUunjRx5D609GCGxLhh3bNvOWFBdSWqUuorS7TY=;
        b=ibQYhu+NMfrBGegCzDryau5OjOLSecLwbYHAWSTyfzyTKykZ5TwTBdkoyNCp8YfAHu
         V9ONd4nRKZ3rT0Nfd5jwe/UVeZemboE+g6Wk2aIbqVnhdF61iy0YtO1yXt2No8+yjF36
         si2r7MPv/pAwCJAI4eKFqW6df+0ZeK99nzzrR9d6Cpo+qWnnj0k+D/He2OG9XBOnc56j
         TbeXWssEz76bxwrs4jqcuTojx36uekLw1RANyP8hEMduTY5Mkn51Rc6m1Su3ryAkLjb9
         oQDmqWne3JrzvtfMXzDYoouXnZp9s2+bSAt50e/eCR2o2T/WJgpntCjxgcx5g9yDhI5o
         j+ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pvjhoUunjRx5D609GCGxLhh3bNvOWFBdSWqUuorS7TY=;
        b=DKXoYtRgr57mt3utlB8Gojxvhq1NAGmeFUiU7q2q344SgXuuqIQ9h8Xz8jC9TKOyNw
         +BvXD9DdhfBYfrTLmBNGHtAo3BAgG9fbOXY2R6BkfyUCt/ZD7LKDfOR9bM7/2UBsmNSi
         ruzpEYtBb+8lUwEPlzDQPONSvUFOECjAyzP8Y4qA4+vfxnjutv29AJGXiPReVAye1Hh8
         VU9CUJFUPshSzcBtu6t8zuu+TCZ9UWkGWPeJ2EzfDJwx6rDlh+wbYpTiBIeIVajSpcQs
         NkwOUAuVzjh96zc+PKV8J/tLGFLd/MTpWb4b+/4Zcvp4rmx1PzWeAhaw/yjPcMMO9+qp
         76ig==
X-Gm-Message-State: AOAM5339Wde4cCCdjZ3np8O+w+Oh2lHrLseGY/eMEarlqvKwP8ABpM+t
        mt7FEnbNDb7Gl8HqluVI+yQuy6T2GPk=
X-Google-Smtp-Source: ABdhPJwluNQlRl8xZhDQUy8OJjrPQN7vZYyvi+jZusXdxw9q3hud2njjQ1Oxs8toiAWGUTwdFdxN5w==
X-Received: by 2002:adf:eecd:0:b0:1ed:e1d3:6cfd with SMTP id a13-20020adfeecd000000b001ede1d36cfdmr499wrp.242.1645657611951;
        Wed, 23 Feb 2022 15:06:51 -0800 (PST)
Received: from [192.168.8.198] ([85.255.236.236])
        by smtp.gmail.com with ESMTPSA id b18sm816146wrx.92.2022.02.23.15.06.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 15:06:51 -0800 (PST)
Message-ID: <d136dc5a-0ec5-2eb4-a64a-cfefe0910f29@gmail.com>
Date:   Wed, 23 Feb 2022 23:06:57 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v3 2/4] io_uring: update kiocb->ki_pos at execution time
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     kernel-team@fb.com
References: <20220222105504.3331010-1-dylany@fb.com>
 <20220222105504.3331010-3-dylany@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220222105504.3331010-3-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/22/22 10:55, Dylan Yudaken wrote:
> Update kiocb->ki_pos at execution time rather than in io_prep_rw().
> io_prep_rw() happens before the job is enqueued to a worker and so the
> offset might be read multiple times before being executed once.
> 
> Ensures that the file position in a set of _linked_ SQEs will be only
> obtained after earlier SQEs have completed, and so will include their
> incremented file position.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov
