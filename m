Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E75B382D70
	for <lists+io-uring@lfdr.de>; Mon, 17 May 2021 15:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbhEQNaT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 May 2021 09:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235885AbhEQNaT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 May 2021 09:30:19 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E846C061573
        for <io-uring@vger.kernel.org>; Mon, 17 May 2021 06:29:02 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id d11so5776462iod.5
        for <io-uring@vger.kernel.org>; Mon, 17 May 2021 06:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1qA1vmwJpWxI4EuPveTmNZouWNPdmf43WuOsk+1G2lY=;
        b=jmzQcb8GH5yNADlM4Oh6onZMgCQK+CwQ7bPW3mi0GJdx1SW9GWi2pER0ZpLZUrHdBv
         73N3Er702O5FAQwnhww63pDmfSSTu2q8R6OrecsNgWplfCWsS+SWD3oxkXNH+JSxofGI
         3XgbXxCS/dkoXNlw6b0riRWvX3UUkFq5IOwxyOy0TwYv30MJNgaaaHZB2NcI6jKFY0si
         K1c6Ce9Z/SuBip6IuixBIyCCJDZAc9CdTQxGoax1PfE/QY14R89OKuAF6rkK59B3XaN0
         enJdg2lgl3fC0ssm5ZSPI5wZ6weXCjICiEnxbrg1xMf9x60qpRuwdO8Y/3u51ZXwZjWy
         Us/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1qA1vmwJpWxI4EuPveTmNZouWNPdmf43WuOsk+1G2lY=;
        b=STWSL07pk/kw8NHKAKiq30/6We00ZcgBnwxVvdYo4odUKt41rTPOJ+JXqf5n9rU5z/
         SozkO8xKImXcaY1gA4X7OG7ncuKOg2EvLjeiFGa5Xp0LQWz7gbHAUUL/r771BpJrNOeP
         iJTnJ+Io8esLNReF99qa1iByz8OYvW2FFgwi6hd21X6a3fZpzNAEK5/RS6L9EhpPgThe
         UtTv3FFB1aaphuSh9VaoxQ7oD+o7IAWn7kWIMrhnR8EbSsQlMG1CsBJuWCXY8VzYtdoN
         oLql2abxINjt2vAP4O9u9hV3fym3EzmoKVk6Hjla9LfmP9fTj82nSHcnWnVxryVPAbki
         +wiw==
X-Gm-Message-State: AOAM530lEWQhgMAv4KQ3Ie/Wly6VNQhK/6Z3shS5uYDVEV4KIiw+Qn3V
        y7n2yDO/qsPvrH+lyFsP48cmlg==
X-Google-Smtp-Source: ABdhPJzKSzS+qEXdHZ3dJLyrzlGqBeCtspuMXr5JNEm5LETYzkf3NU13x6lmySw3dcyV7n4ERYKu4w==
X-Received: by 2002:a02:ba08:: with SMTP id z8mr23491jan.74.1621258141799;
        Mon, 17 May 2021 06:29:01 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 67sm6423404iow.16.2021.05.17.06.29.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 06:29:01 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: don't modify req->poll for rw
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     syzbot+a84b8783366ecb1c65d0@syzkaller.appspotmail.com
References: <4a6a1de31142d8e0250fe2dfd4c8923d82a5bbfc.1621251795.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b043765c-320c-ecb0-46f9-1da2c5bffd35@kernel.dk>
Date:   Mon, 17 May 2021 07:29:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4a6a1de31142d8e0250fe2dfd4c8923d82a5bbfc.1621251795.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/21 5:43 AM, Pavel Begunkov wrote:
> __io_queue_proc() is used by both poll and apoll, so we should not
> access req->poll directly but selecting right struct io_poll_iocb
> depending on use case.

Applied, thanks.

-- 
Jens Axboe

