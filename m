Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE0BD128A9A
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 18:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfLUR1J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 12:27:09 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40705 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfLUR1J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 12:27:09 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so12399766wrn.7;
        Sat, 21 Dec 2019 09:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=nVid9D173yh4EMZcJw3nWzl1fa7hs8Vk6UFcLPZjzfI=;
        b=qxtsgWyA2Mv7aW9HOd5jMYby+zsyE1l0TR8aVl5QMPRW1ce0+eLUShSyA4QWW2l0aT
         UqQKxZqdHIY7Y6zhdCLaI+SGDu22yRrjmgT7yBbZFOIoQlSksmqMqYezDvcgvDm6s+KD
         6wc8QdNO+CZb4K94VIMD5XF+e0WfF5eNWlt0WSWgJ2zsdm8VK8ZuEAbwqEIscT+9KlQN
         P1ldymZ1c0t1ofcc4GDePOhjwXy8HDGAK9KP2mJMAHHViRikV0lGU6ss5BOUI2c3CCMc
         MnMkuILp1wu0yB+Bf1FP4Y0n0VIjz86sAbk+l3O3nDW5mqHE10Ptt0MhDqkErloyUAuT
         tAjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=nVid9D173yh4EMZcJw3nWzl1fa7hs8Vk6UFcLPZjzfI=;
        b=PkmBXTqK0Z1dJreY2rrJqnKek3WTvLHAqC+BZS+FZ/A6Unj2zLCofbc2/pBNJBKu40
         c8cQr0MfyxI6/leefgqw5dd6/l3AdqvWchQ18kLQ/aA1zEVYBwaGn4ktBzgdw5qiIclm
         0KW5bJ35pkzheBpCxPvSNeqN3DOrNaLOSztkzYFvV5VWEH3KODWHYqXqCBipSwpcgcgx
         C23Mkkaz2sIgcpIsis2Z4j0c0meXmCWPOyndO+FwxGDUzX8l2cYFbB4GjNl4jM31AM5f
         2uqTp05Ug7dDTezXjW4HCa0f2de6ih9DFGv9vhuc180J0fIMAyShvXnVV+nGSgB/ONrf
         SjbQ==
X-Gm-Message-State: APjAAAXBYLIlNWHnVkY+ylr8xrdnAjVXleNHcUreSMvnBVH5KxcBpNu/
        WGfijXY3JN1v1CIuQTRVFtM=
X-Google-Smtp-Source: APXvYqxAjJ15GygaoCCET6WfqZr/51lOel1eaitsXNN0qIOCyRIGCkvwSVVH1h/0ASl5V6IwsnRbAg==
X-Received: by 2002:adf:f052:: with SMTP id t18mr21037908wro.192.1576949225836;
        Sat, 21 Dec 2019 09:27:05 -0800 (PST)
Received: from [192.168.43.10] ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id f1sm14241567wro.85.2019.12.21.09.27.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Dec 2019 09:27:05 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
        Christoph Lameter <cl@linux.com>
References: <cover.1576944502.git.asml.silence@gmail.com>
 <925d8fe5406779bbfa108caa3d1f9fd16e3434b5.1576944502.git.asml.silence@gmail.com>
 <da858877-0801-34c3-4508-dabead959410@gmail.com>
 <ff85b807-83e1-fd05-5f85-dcf465a50c11@kernel.dk>
 <fef4b765-338b-d3b0-7fd5-5672b92fd3e8@gmail.com>
 <fef3a245-d2a2-23b3-ff03-3e05af19b752@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH RFC v2 3/3] io_uring: batch get(ctx->ref) across submits
Message-ID: <b5c0e2ab-ded3-d06b-afda-e7a72f1368e4@gmail.com>
Date:   Sat, 21 Dec 2019 20:26:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <fef3a245-d2a2-23b3-ff03-3e05af19b752@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AzNQoLv2McupmGhnzJNm9urb2gLHcd6HN"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AzNQoLv2McupmGhnzJNm9urb2gLHcd6HN
Content-Type: multipart/mixed; boundary="3uFrkmDlTApU8qTA9VHwffF0MAgdcG3lG";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>
Message-ID: <b5c0e2ab-ded3-d06b-afda-e7a72f1368e4@gmail.com>
Subject: Re: [PATCH RFC v2 3/3] io_uring: batch get(ctx->ref) across submits
References: <cover.1576944502.git.asml.silence@gmail.com>
 <925d8fe5406779bbfa108caa3d1f9fd16e3434b5.1576944502.git.asml.silence@gmail.com>
 <da858877-0801-34c3-4508-dabead959410@gmail.com>
 <ff85b807-83e1-fd05-5f85-dcf465a50c11@kernel.dk>
 <fef4b765-338b-d3b0-7fd5-5672b92fd3e8@gmail.com>
 <fef3a245-d2a2-23b3-ff03-3e05af19b752@kernel.dk>
In-Reply-To: <fef3a245-d2a2-23b3-ff03-3e05af19b752@kernel.dk>

--3uFrkmDlTApU8qTA9VHwffF0MAgdcG3lG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 21/12/2019 20:01, Jens Axboe wrote:
> On 12/21/19 9:48 AM, Pavel Begunkov wrote:
>> On 21/12/2019 19:38, Jens Axboe wrote:
>>> On 12/21/19 9:20 AM, Pavel Begunkov wrote:
>>>> On 21/12/2019 19:15, Pavel Begunkov wrote:
>>>>> Double account ctx->refs keeping number of taken refs in ctx. As
>>>>> io_uring gets per-request ctx->refs during submission, while holdin=
g
>>>>> ctx->uring_lock, this allows in most of the time to bypass
>>>>> percpu_ref_get*() and its overhead.
>>>>
>>>> Jens, could you please benchmark with this one? Especially for offlo=
aded QD1
>>>> case. I haven't got any difference for nops test and don't have a de=
cent SSD
>>>> at hands to test it myself. We could drop it, if there is no benefit=
=2E
>>>>
>>>> This rewrites that @extra_refs from the second one, so I left it for=
 now.
>>>
>>> Sure, let me run a peak test, qd1 test, qd1+sqpoll test on
>>> for-5.6/io_uring, same branch with 1-2, and same branch with 1-3. Tha=
t
>>> should give us a good comparison. One core used for all, and we're go=
ing
>>> to be core speed bound for the performance in all cases on this setup=
=2E
>>> So it'll be a good comparison.
>>>
>> Great, thanks!
>=20
> For some reason, not seeing much of a change between for-5.6/io_uring
> and 1+2 and 1+2+3, it's about the same and results seem very stable.
> For reference, top of profile with 1-3 applied looks like this:

I see. I'll probably drop the last one, as it only complicates things.

My apologies for misleading terminology. Read-only QD1 (submit and
wait until the userspace completes it) obviously won't saturate a CPU.
Writes probably wouldn't as well (though, depends on HW). And it would be=

better to say -- submit by one, complete in a bunch.
Just curious, what you used for testing? Is it fio?

>=20
> +    3.92%  io_uring  [kernel.vmlinux]  [k] blkdev_direct_IO
> +    3.87%  io_uring  [kernel.vmlinux]  [k] blk_mq_get_request
> +    3.43%  io_uring  [kernel.vmlinux]  [k] io_iopoll_getevents
> +    3.03%  io_uring  [kernel.vmlinux]  [k] __slab_free
> +    2.87%  io_uring  io_uring          [.] submitter_fn
> +    2.79%  io_uring  [kernel.vmlinux]  [k] io_submit_sqes
> +    2.75%  io_uring  [kernel.vmlinux]  [k] bio_alloc_bioset
> +    2.70%  io_uring  [nvme_core]       [k] nvme_setup_cmd
> +    2.59%  io_uring  [kernel.vmlinux]  [k] blk_mq_make_request
> +    2.46%  io_uring  [kernel.vmlinux]  [k] io_prep_rw
> +    2.32%  io_uring  [kernel.vmlinux]  [k] io_read
> +    2.25%  io_uring  [kernel.vmlinux]  [k] blk_mq_free_request
> +    2.19%  io_uring  [kernel.vmlinux]  [k] io_put_req
> +    2.06%  io_uring  [kernel.vmlinux]  [k] kmem_cache_alloc
> +    2.01%  io_uring  [kernel.vmlinux]  [k] generic_make_request_checks=

> +    1.90%  io_uring  [kernel.vmlinux]  [k] __sbitmap_get_word
> +    1.86%  io_uring  [kernel.vmlinux]  [k] sbitmap_queue_clear
> +    1.85%  io_uring  [kernel.vmlinux]  [k] io_issue_sqe
>=20
>=20

--=20
Pavel Begunkov


--3uFrkmDlTApU8qTA9VHwffF0MAgdcG3lG--

--AzNQoLv2McupmGhnzJNm9urb2gLHcd6HN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl3+Vb4ACgkQWt5b1Glr
+6VXmw/+LRykB19lWgcVBsDxfV/IHwejEFsVMlB00nBZWGiaqBM5OvrpQ9cTF/tO
LPcKZweG0Nt8o5x/PAypzdjU26rSn33mPpqn7SK6fbO9x/mxxykBGyNm9NCdhG3y
NN2vMFRyWH0C0XFVyxX+Mkxetj6PUvlPmRtfbOocKkac5jnuNPL6e1nMEHanDLc2
b9M4t64xHH61Kkhj0/8fEvhoyMi+kaS2JpsvsjhkswGrJSGKERyWP45CM2S+D3AC
HW7h/0huSN3snpZZJk1ZHlL+OhspNflEhtf5vDUQoBDu0SsGLzXUtutFkpNLoe0c
G7B2yLNNH6Q2YLLRwcS5y8qeujW7EqPR/YbdRwYo+wmSXuxK4Aqwjh1KWxh7AJOX
kVOmXitJvb9154OeEQ/Fk0SNPH2TlOeNRJDxZ63yx357uCHVnNxhD7YqURxPsen3
CzVi/OV5Gnn65DXeEYj3uSTC9UDRy6QB3Qco1SPt/Gtg9PIpwR0NYmzt56FiB2C3
43vtp7rc3VsVPqoQ1UC/21pGgZFnuOo24npQiNtTFf1PKFNIZpmPEEs3DXbENKGr
SSi2mCUuhx1PG08iuBL6fB+Mq6MVA3zCp0UapKPRhFYSldJjdiJLveEIKNBQWvs7
83E8C0736CE0/vH0a9VQv63CdrF5Vnddk8yWX/HgdMZiJgbN5Nw=
=D3tA
-----END PGP SIGNATURE-----

--AzNQoLv2McupmGhnzJNm9urb2gLHcd6HN--
