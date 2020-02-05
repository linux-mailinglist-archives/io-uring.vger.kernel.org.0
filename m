Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9661534A4
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2020 16:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgBEPyZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Feb 2020 10:54:25 -0500
Received: from mail-il1-f170.google.com ([209.85.166.170]:38722 "EHLO
        mail-il1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgBEPyX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Feb 2020 10:54:23 -0500
Received: by mail-il1-f170.google.com with SMTP id f5so2264744ilq.5
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2020 07:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=K/TEbJFWEtJ7myelS/+rh6TG8Nyyi+LUMKE4sDPf1rk=;
        b=2DAa94e6a/x2+aZvMCSs+SwO191hwhcxjL9ORz3MeaiM7QD6UI/y5uXhii6zCOtGxD
         Ao68VSG9ANXirxvEHg31qu+hk4UtS8gkP+RgBF4kI7ysUTqTp9B35Yx7P1i3xQeF3kpF
         HSv9V6w3pDzlhBFjbfV+9WJagOG8KuvTojdydEqoTFOmXGqsDbysJ+m33AGXI4lLghOR
         r86lZDz+//el2LiYv2NEKsMCzBo6RM+2PXZs/7o6uZ4wUYz76Q77zof61X07yhEXCoU3
         lUiV6nmvVxWGT92jf50syh3y47zCVzyQD6lsIB0daDXUfTqZxlg05+zsS7OhyC8DIKyY
         QaLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K/TEbJFWEtJ7myelS/+rh6TG8Nyyi+LUMKE4sDPf1rk=;
        b=nr2vog/GeiOKlWWBTshU7xd4C4z3C/hhe6dLMcQavR03azMJwYbLbY/tN+z1hGevN/
         qTerdJgakGDykwgKMmPybx8vu4N14UuNEcFMl523UxPfG7zMZF7qu4k8QxvEfKZ66att
         +U2z3/T3Qr4hsudRs4fZEjXjldJHrTr0VUqaCRW9PpeTyCGpkQxfoRTMHPvpPU8MXrOL
         Z/OnBFKxx2+ho0Y3UcdTbmc5cqFjwUr5H+70uEAFHlNfH1FJdqMF1SC7fkTeEW0XkoSE
         uEGlJOB+27ackiIPfQSyuMA52eYHer8v8KJtwFBLUUTx+0qUPGdOrk0HwyOITv0pv9av
         dSSQ==
X-Gm-Message-State: APjAAAVzBQu+skvLYYthjYF+O6Q8jr5y3bRZC4dPlnoI8dXmkiVVli4O
        /7gGUxgyzT98EPzViCoShkYFAE1Q06o=
X-Google-Smtp-Source: APXvYqzWXlbgLJfIBrB+xCBg3yB7cebqo/qOH8x84HpGW+NlmiRh3flk2lxkQXchXo176LKhA4ND7w==
X-Received: by 2002:a92:48c2:: with SMTP id j63mr25700622ilg.153.1580918061800;
        Wed, 05 Feb 2020 07:54:21 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r14sm10464783ilg.59.2020.02.05.07.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 07:54:21 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix mm use with IORING_OP_{READ,WRITE}
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <951bb84c8337aaac7654261a21b03506b2b8a001.1580914723.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <df11c48e-f456-3b64-88d1-6012b1ac2bc8@kernel.dk>
Date:   Wed, 5 Feb 2020 08:54:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <951bb84c8337aaac7654261a21b03506b2b8a001.1580914723.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/5/20 8:46 AM, Pavel Begunkov wrote:
> IORING_OP_{READ,WRITE} need mm to access user buffers, hence
> req->has_user check should go for them as well. Move the corresponding
> imports past the check.

I'd need to double check, but I think the has_user check should just go.
The import checks for access anyway, so we'll -EFAULT there if we
somehow messed up and didn't acquire the right mm.

-- 
Jens Axboe

