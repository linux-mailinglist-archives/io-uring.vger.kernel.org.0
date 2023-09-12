Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A8679D890
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 20:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237211AbjILSWF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Sep 2023 14:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbjILSWF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Sep 2023 14:22:05 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3969A115
        for <io-uring@vger.kernel.org>; Tue, 12 Sep 2023 11:22:01 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-34f17290a9cso7083685ab.1
        for <io-uring@vger.kernel.org>; Tue, 12 Sep 2023 11:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694542920; x=1695147720; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HDJjXRWaPhUV+fdG72AFXvoZh+zwBrqOn19CM5q9bnQ=;
        b=VojIkoAq2THSYdYGGaZa1GwW99cstmjIav63ZY/XQKE41sdleiEQ/MuKMO8lZd2uu+
         xLv2WtpMC70m5YiVulEzg6IFn2TfMXWFdahQ6+g4dereSOQidFcY6jx2+erX2lnJ578D
         /Rzf75meXdYi9wsT54rS/Yfk7ZmB4kmrON7FoQ0zIeH8r0i+iG3iHQBjE+VOULnqKcWu
         mPZrFaQsMPT2WeUkd+HUaosGEKgZUrLKfeu9GIgZWnHJV0vLGCskpD6qgtsdD77fP1dF
         yumHkGU5Z6E+XpK3LNX7UeebPyLhRzu8r6fI5B9yWbbW5kRJ4Vf8Pod9Yl9W67xGbjdJ
         +auQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694542920; x=1695147720;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HDJjXRWaPhUV+fdG72AFXvoZh+zwBrqOn19CM5q9bnQ=;
        b=KdCzYv0Sp3WW09kl9+9Wpmj0ktRbfFNep34tKpwsM6egdQP3PbaK1AUDN271yDVcFi
         H3W+SSQEI3j0aLDdT/c7XBMJMyGp2+LuH/WGfAF0hdryw1T1hyaJEwEDOiH0UHtKs/WO
         OVLN5xmqgmL+pjmgxsGJkbkX6GkKIbonDX3f2+UY0AMguHvLXx+KBuUjFqbzsNa8yRHn
         xML6uiz37O7qmaqgGNogyHpQ24LywgIkluE2wXr8PaR0Lzsj5BILg+hwhnF7PuUc4RnX
         a9SbMjyfpcnjymjWpM5a3yvs7B9isR+fswV7WyL4l9PAVn5FjKQv/5xPoGHbOb+K0iT5
         FFBg==
X-Gm-Message-State: AOJu0YzGvlAXNy/JbYxi2uEZz2lPzGhSUY2KmGfEHl6H4AY9bj1kK6rW
        mi3WPvGTW2LywgLJ0Il9WQLvZkTO+hESr2FmrE6ZDw==
X-Google-Smtp-Source: AGHT+IHsS0eMsu4BhZ+A9fyOb9/jMw0fwfJGG8AeeBevaHRZ8kSb9x+CgvlR8PIFmrRtEqLH6kXZ9g==
X-Received: by 2002:a92:c9c2:0:b0:34f:7ba2:50e8 with SMTP id k2-20020a92c9c2000000b0034f7ba250e8mr347169ilq.2.1694542919735;
        Tue, 12 Sep 2023 11:21:59 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l3-20020a056e0205c300b003459023deaasm3231570ils.30.2023.09.12.11.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Sep 2023 11:21:59 -0700 (PDT)
Message-ID: <7c169870-190c-4b63-9a5b-30d6c41f7e99@kernel.dk>
Date:   Tue, 12 Sep 2023 12:21:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring/rw: add support for IORING_OP_READ_MULTISHOT
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, krisman@suse.de
References: <20230912172458.1646720-1-axboe@kernel.dk>
 <20230912172458.1646720-4-axboe@kernel.dk>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230912172458.1646720-4-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/12/23 11:24 AM, Jens Axboe wrote:
> @@ -863,10 +879,61 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
>  	int ret;
>  
>  	ret = __io_read(req, issue_flags);
> -	if (unlikely(ret < 0))
> -		return ret;
> +	if (ret >= 0)
> +		return kiocb_done(req, ret, issue_flags);
> +
> +	return ret;
> +}

Looks like this one got folded into the wrong patch, this belongs with
patch 1 of course. The current git tree is correct, patch 1 does it this
way and patch 3 doesn't touch it.

-- 
Jens Axboe

